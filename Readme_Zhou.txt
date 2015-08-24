This model is for 0.5 deg resolution (ISI-MIP)

To change it to 0.25 deg, some hard coded places need to be checked. e.g. the searching radius should be changed to 10 gridcells instead of 5 gridcells from river stem. etc.

The steps to run the reservoir model
1.	The base directory of the reservoir model is located in /net/power/raid/tizhou/BASE
2.	To run a new basin (e.g. Colorado), please create a new directory (e.g. Colorado_run) and copy everything in BASE to the new directory.
3.	Update 3 files for your basin: 
a) flow direction file /BasinRun/data/rivernetwork/ddm30_watch_2009/dir30min_overlap/38801.dir
b) fraction file
/BasinRun/data/rivernetwork/ddm30_watch_2009/frac30min/38801.frac
c) mask file
/BasinRun/data/rivernetwork/ddm30_watch_2009/mask30min/38801.xmask
4.	Run the "makeexe.sh" in BasinRun directory to change the permission of executables
5.	Run "run_irrig.sh 38801 2 -b -c -d -e -f -g -h -i -j¡± ("2" indicates no reservoir no irrigation scenario) 
6.	Run "run_irrig.sh 38801 5 -j". ("5" indicates reservoir and irrigation scenario)
7.	The results are located in /BasinRun/run/rout/output/wfd/baseline/irrig.res.wb.24hr/

Notes:
1.	Before running the reservoir model, two sets of vic runs (regular run and water free run) must be completed. The global parameter files, soil parameters, and results are located in /net/power/raid/tizhou/Global_run
2.	The forcing data are located in /net/power/raid/tizhou/Global_met/asc_vicinp
3.	Most of the paths, file names are defined in /BasinRun/run_irrig.sh
4.	There are five scenarios: 1) irrigation without reservoir; 2) no irrigation no reservoir; 3) free water irrigation no reservoir; 4) no irrigation with reservoir; and 5) irrigation and reservoir.
5.	In most cases we just need to run scenarios 2 and 5. The purpose to run 2 is to derive the minimum flow (7Q10) and the annual flood (bankfull flow over a year).
6.	Step -b generates frac.txt in /BasinRun and soil.current in /BasinRun/run/input/soil
7.	Step -c generates irri.38801.gmt and irr.38801.asc in /BasinRun
8.	Step -d copies the forcing data from the Global_met directory to /BasinRun/data/met/asc_vicinp and the vic results from Global_run directory to /BasinRun/run/output/wfd/baseline/
9.	Step -e generates 38801.reservoirs.firstline and 38801.points in /BasinRun/run/rout/input
10.	Step -f generates 38801.reservoirs.upstream and 38801.reservoirs.extractwater in /BasinRun. It also generates XXX.cal.irrdemand.monthly (XXX denotes the dam name) in /BasinRun/data/dames/unh/2000
11.	Step -g generates n files in /BasinRun/run/input/soil/points; n is the number of cells with irrigation fraction >0
12.	Step -h converts the binary vic output to ascii in /BasinRun/run/output/daily.ascii
13.	Step -I generates upstreamcells.txt in /BasinRun
14.	Step -j runs the run_vic.sh in /BasinRun/programs/scripts
15.	Run_vic.sh uses most of the scripts and C programs located in /BasinRun/programs
16.	Run_vic.sh goes through the irrigated cells from upstream to downstream.

Source code:
1.	VIC : /net/power/raid/tizhou/BASE/BasinRun/models/vic
2.	ROUT : /net/power/raid/tizhou/BASE/BasinRun/models/rout/rout_new
3.	MOSCEM: /net/power/raid/tizhou/BASE/BasinRun/models/rout/moscem
4.	Misc c programs: /net/power/raid/tizhou/BASE/BasinRun/programs/C
  a)	clipbinaryfluxes.c
  b)	col2grid.c
  c)	dams.find.irrigationwaterdemand.c
  d)	dams.find.irrigationwaterdemand.c.withskip
  e)	dams.gages.withinbasin.makeroutinput.c
  f)	find.upstreamcells.c
  g)	fluxdata.binary.to.daily.ascii.allcolc.c
  h)	fluxdata.binary.to.daily.ascii.c
  i)	fluxdata.binary.to.daily.ascii.c.withskip
  j)	metdata.modify.runoff.c
  k)	routing.modifystationfile.c
  l)	routing.subtract.water.used.for.irrigation.c
  m)	routing.subtract.water.used.for.irrigation.c~
  n)	soilfile.rearrangepoints.c
5.	Misc scripts: /net/power/raid/tizhou/BASE/BasinRun/programs/scripts
  a)	copy_files.sh
  b)	global.file.modify.sh
  c)	latlon.from.fractionfile.sh
  d)	make_irrig_subset.sh
  e)	make_llf.sh
  f)	make_routing_input_files.sh
  g)	make_soil_subset.sh
  h)	routing.modify.inputfile.sh
  i)	run_vic.sh
  j)	soilfile.extract.cells.sh
  k)	upstream.extract.cell.sh
