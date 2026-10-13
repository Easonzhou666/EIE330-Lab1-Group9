#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for tool in iverilog vvp yosys dot python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing tool: $tool. Send this message to your assistant; do not upgrade Ubuntu."
    exit 2
  fi
done
mkdir -p build
python3 - <<'PYMETA'
import datetime, hashlib, json, platform
from pathlib import Path
files=sorted(Path('RTL').glob('*.v'))+sorted(Path('sim').glob('*.v'))
meta={'run_started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(), 'platform':platform.platform(), 'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
Path('build/run_metadata.json').write_text(json.dumps(meta,indent=2))
PYMETA
iverilog -V > build/iverilog_version.txt 2>&1
yosys -V > build/yosys_version.txt 2>&1
for top in full_adder_top comparator_top; do
  echo "Checking $top"
  iverilog -g2012 -Wall -t null -s "$top" "RTL/$top.v" > "build/${top}_syntax.log" 2>&1
  iverilog -g2012 -Wall -s "${top}_tb" -o "build/$top.vvp" "RTL/$top.v" "sim/${top}_tb.v" > "build/${top}_compile.log" 2>&1
  (cd build && vvp "$top.vvp") | tee "build/${top}_simulation.log"
  yosys -p "read_verilog RTL/$top.v; hierarchy -check -top $top; proc; opt; check; stat; show -format dot -prefix build/${top}_rtl $top" > "build/${top}_yosys.log" 2>&1
  dot -Tpdf "build/${top}_rtl.dot" -o "build/${top}_rtl.pdf"
  if grep -i 'warning' "build/${top}_syntax.log" "build/${top}_compile.log" "build/${top}_yosys.log"; then
    echo "Warnings found. Review the logs before claiming warning-free verification."
    exit 3
  fi
done
python3 - <<'PYCHECK'
import csv
from pathlib import Path
for name,count in [('full_adder_top',8),('comparator_top',4)]:
    with open('build/'+name+'_results.csv') as f: rows=list(csv.DictReader(f))
    if len(rows)!=count or any(row['pass']!='1' or row['expected_logical']!=row['actual_logical'] for row in rows):
        raise SystemExit('Result validation failed: '+name)
    print(name+': all '+str(count)+' recorded cases passed')
Path('build/VERIFICATION_COMPLETE.txt').write_text('Syntax, generic synthesis and all static functional test cases completed. Board testing is separate.\n')
PYCHECK
if python3 -c 'import matplotlib, vcdvcd' >/dev/null 2>&1; then
  python3 plot_vcd.py full_adder_top
  python3 plot_vcd.py comparator_top
else
  echo "Plot packages not present. VCD data is saved; send it to your assistant for plotting."
fi
python3 - <<'PYZIP'
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
with ZipFile('Lab1_Results.zip','w',ZIP_DEFLATED) as z:
    for folder in ['RTL','sim','build']:
        for p in sorted(Path(folder).rglob('*')):
            if p.is_file(): z.write(p,p)
    for filename in ['run_all.sh','plot_vcd.py','README.md']:
        z.write(filename,filename)
print('Created Lab1_Results.zip. Send this file back for the report.')
PYZIP
