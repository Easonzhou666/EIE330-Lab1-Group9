from pathlib import Path
import sys
import matplotlib.pyplot as plt
from vcdvcd import VCDVCD
name = sys.argv[1]
if name not in ("full_adder_top", "comparator_top"):
    raise SystemExit("Specify full_adder_top or comparator_top")
vcd = VCDVCD(str(Path("build") / (name + ".vcd")), store_tvs=True)
signals = ["a", "b", "cin", "s", "cout"] if name == "full_adder_top" else ["a", "b", "lt", "eq", "gt"]
fig, axes = plt.subplots(len(signals), 1, figsize=(8, 3.6), sharex=True)
for ax, signal in zip(axes, signals):
    key = name + "_tb.dut." + signal
    tv = vcd[key].tv
    x = [t for t, value in tv]
    y = [int(value, 2) if set(value) <= {"0", "1"} else float("nan") for t, value in tv]
    ax.step(x + [vcd.endtime], y + [y[-1]], where="post")
    ax.set_ylabel(signal, rotation=0, labelpad=20)
    ax.set_yticks([0, 1]); ax.set_ylim(-0.2, 1.2); ax.grid(alpha=.2)
axes[-1].set_xlabel("VCD time ticks (check the $timescale in the VCD header)")
fig.tight_layout()
fig.savefig(Path("build") / (name + "_actual.pdf"))
