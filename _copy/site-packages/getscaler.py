"""
getscaler.py - last changed 2020-04-08
python 3.6+ is needed

A "companion" program to getnative.
Keep in mind that the scaler with the smallest error isn't neccesarily the one being used
and that some things are NOT to be descaled. 
Use at your own discretion.

Prerequisites:
vapoursynth (duh): http://www.vapoursynth.com/
fmtc: https://github.com/EleonoreMizo/fmtconv/releases
ffms2: https://github.com/FFMS/ffms2/releases

Example runs:
python getscaler.py "input.mkv" -nh 810
python getscaler.py "input.mkv" -nh 810 -f 912
python getscaler.py "script.vpy" -s -nh 853

Most of the hard work here was done by kageru and Infi, I was just merging scripts around.
Their scripts can be seen here:
https://github.com/Infiziert90/getnative/blob/master/getnative.py
https://gist.github.com/kageru/549e059335d6efbae709e567ed081799
"""
from argparse import ArgumentParser
from functools import partial
from random import randint

import vapoursynth as vs

core = vs.core


class Scaler:
    kernel: str = "Unknown"
    params: dict = {}
    descaler: object = None

    def __init__(self, **kwargs):
        self.params = kwargs

    @classmethod
    def from_args(cls, kernel, descaler, **kwargs):
        instance = cls(**kwargs)
        instance.kernel = kernel
        instance.descaler = descaler
        return instance

    def name(self):
        if not self.params:
            return self.kernel

        niceargs = ", ".join(f"{k}={v:.2G}" for k, v in self.params.items())
        return f"{self.kernel} ({niceargs})"


class BicubicScaler(Scaler):
    kernel = "Bicubic"
    descaler = core.descale.Debicubic


class LanczosScaler(Scaler):
    kernel = "Lanczos"
    descaler = core.descale.Delanczos


class RobidouxScaler(Scaler):
    descaler = core.descale.Debicubic

    def __init__(self, kernel, **kwargs):
        self.kernel = kernel
        self.params = kwargs


class FmtcScaler(Scaler):
    def __init__(self, kernel, **kwargs):
        self.kernel = kernel
        self.descaler = partial(core.fmtc.resample, kernel=kernel.lower(), invks=True)
        self.params = kwargs


# list of (de)scaling functions to iterate through

scalers = [
    Scaler.from_args(kernel="Bilinear", descaler=core.descale.Debilinear),
    BicubicScaler(b=1 / 3, c=1 / 3),
    BicubicScaler(b=0.5, c=0),
    BicubicScaler(b=0, c=0.5),
    BicubicScaler(b=1, c=0),
    BicubicScaler(b=0, c=1),
    BicubicScaler(b=0.2, c=0.5),
    LanczosScaler(taps=3),
    LanczosScaler(taps=4),
    LanczosScaler(taps=5),
    Scaler.from_args(kernel="Spline16", descaler=core.descale.Despline16),
    Scaler.from_args(kernel="Spline36", descaler=core.descale.Despline36),
    RobidouxScaler("Robidoux", b=0.3782, c=0.3109),
    RobidouxScaler("Robidoux Sharp", b=0.2620, c=0.3690),
    RobidouxScaler("Robidoux Soft", b=0.6796, c=0.1602),
    FmtcScaler("Sinc"),
    FmtcScaler("Gauss"),
]


# original: https://gist.github.com/kageru/549e059335d6efbae709e567ed081799#file-getnative-py-L102
def getw(h, ar):
    return int(round(h * ar)) // 2 * 2


# stolen from infi (https://github.com/Infiziert90/getnative/blob/master/getnative.py#L187), modified
def upsizer(clip: vs.VideoNode, width: int, height: int, scaler: Scaler):
    if isinstance(scaler, BicubicScaler) or isinstance(scaler, RobidouxScaler):
        upsizer = partial(
            clip.resize.Bicubic,
            filter_param_a=scaler.params["b"],
            filter_param_b=scaler.params["c"],
        )

    elif isinstance(scaler, LanczosScaler):
        upsizer = partial(clip.resize.Lanczos, filter_param_a=scaler.params["taps"])

    elif isinstance(scaler, FmtcScaler):
        upsizer = partial(
            clip.fmtc.resample, kernel=scaler.kernel.lower(), **scaler.params
        )

    else:
        upsizer = getattr(clip.resize, scaler.kernel)

    return upsizer(width, height)


# based on code stolen from kageru and infi (getnative versions above)
def geterror(clip: vs.VideoNode, h: int, scaler: Scaler):
    aspect_ratio = clip.width / clip.height

    down = scaler.descaler(clip, getw(h, aspect_ratio), h, **scaler.params)
    up = upsizer(down, getw(clip.height, aspect_ratio), clip.height, scaler)

    smask = core.std.Expr([clip, up], "x y - abs dup 0.015 > swap 0 ?")
    smask = core.std.CropRel(smask, 5, 5, 5, 5)

    mask = core.std.PlaneStats(smask)
    luma = mask.get_frame(0).props.PlaneStatsAverage
    return luma


if __name__ == "__main__":
    parser = ArgumentParser(
        description="Find the best inverse scaler for a given frame"
    )
    parser.add_argument(
        dest="input_file",
        type=str,
        help="Absolute or relative path to the input file (video/script/image)",
    )
    parser.add_argument(
        "--native_height",
        "-nh",
        dest="native_height",
        type=int,
        default=720,
        help="Approximated native height. Default is 720",
    )
    parser.add_argument(
        "--frame",
        "-f",
        dest="frame",
        type=int,
        default=None,
        help="Specify a frame for the analysis. Random if unspecified",
    )
    parser.add_argument(
        "--as_script",
        "-s",
        dest="is_script",
        action="store_true",
        help="Treat input file as a script",
    )

    args = parser.parse_args()

    # importing the src for descaling.
    src = None
    is_image = False

    if args.is_script:
        print("Treating input file specified as script...")
        exec(open(args.input_file, "r").read())
        src = vs.get_output(0)

    else:
        if args.input_file.endswith(".png") or args.input_file.endswith(".jpg"):
            src = core.imwri.Read(args.input_file)
            is_image = True
        else:
            src = core.ffms2.Source(args.input_file)

    # frame to use
    frame = args.frame
    if args.frame is None:
        frame = randint(0, src.num_frames)

    # upsample and set to desired frame
    luma32 = src.resize.Point(format=vs.YUV444PS, matrix_s="709").std.ShufflePlanes(
        0, vs.GRAY
    )
    if not is_image:
        luma32 = luma32[frame]

    # set for descaling test
    results_bin = []

    # evaluate across all scalers
    for scaler in scalers:
        error = geterror(luma32, args.native_height, scaler)
        results_bin.append((scaler.name(), error))

    # sort values
    results_bin.sort(key=lambda tup: tup[1])
    best = results_bin[0]

    # print results
    print(f"For frame {frame} (native height: {args.native_height}p):")
    print("------------------------------------------------------------")
    print(f'{"Scaler":<24}\t{"Error%":>8}\tAbs. Error')
    for name, abserr in results_bin:
        relerr = abserr / best[1] if best[1] != 0 else 0
        print(f"{name:<24}\t{relerr:>8.1%}\t{abserr:.10f}")
    print("------------------------------------------------------------")
    print(f'Smallest error achieved by "{best[0]}" ({best[1]:.10f})')
