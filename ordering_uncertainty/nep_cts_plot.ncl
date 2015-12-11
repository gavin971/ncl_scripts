;
;plot gpp ts_data
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;*******************************************
begin
;*******************************************
  g2Pg=1.e-15
  km2tom2=1.e6
  areag2Pg=g2Pg*km2tom2*86400.
  mondaz=(/31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31./)
  tscal=86400.*365.;   total number of seconds per year
  time=fspan(2001,2299,299*12)
;*******************************************
; read files
;*******************************************
  mother_dir="/Users/JinyunTang/data_mirror/RCP45/"
  grd_dir="/Users/JinyunTang/data_mirror/ncl_scripts/clm_grids/"
;************************************************
; load area
;************************************************
  file_name=str_concat((/grd_dir,"area_1.9x2.5.nc"/))
  grid_in=addfile(file_name,"r")
  area=grid_in->area

;************************************************
; read default carbon flux
;************************************************

  child_dir="betr_cent_derive/"
  stem_name="carbon_flux.RCP45"
  postfixer=".2001-2300.nc"
  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEE

  szs=dimsizes(npp)
  i=0
  ;declare an array for the time series
  npp_ts_mon=new(szs(0),float)

  do while( i .lt. szs(0))
    npp_loc=rm_single_dims(npp(i,:,:))
    npp_loc = npp_loc*area
    mon=mod(i,12)
    npp_ts_mon(i) =sum(npp_loc)*areag2Pg*mondaz(mon)
    i=i+1
  end do

  npp_ts_yr_default = cumsum(npp_ts_mon, 0)
;************************************************
; read cent
;************************************************
  delete(cn_flx_in)
  delete(npp)
  child_dir="betr_clm_derive/"

  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEE
  i=0
  do while( i .lt. szs(0))
    npp_loc=rm_single_dims(npp(i,:,:))
    npp_loc = npp_loc*area
    mon=mod(i,12)
    npp_ts_mon(i) =sum(npp_loc)*areag2Pg*mondaz(mon)
    i=i+1
  end do
  npp_ts_yr_cent = cumsum(npp_ts_mon, 0)
;************************************************
;read clm
;************************************************
  delete(cn_flx_in)
  delete(npp)
  child_dir="betr_clm3_derive/"

  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEE
  i=0
  do while( i .lt. szs(0))
    npp_loc=rm_single_dims(npp(i,:,:))
    npp_loc = npp_loc*area
    mon=mod(i,12)
    npp_ts_mon(i) =sum(npp_loc)*areag2Pg*mondaz(mon)
    i=i+1
  end do
  npp_ts_yr_clm = cumsum(npp_ts_mon, 0)
;************************************************
;read clmo
;************************************************
  delete(cn_flx_in)
  delete(npp)
  child_dir="betr_clmo_derive/"

  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEE
  i=0
  do while( i .lt. szs(0))
    npp_loc=rm_single_dims(npp(i,:,:))
    npp_loc = npp_loc*area
    mon=mod(i,12)
    npp_ts_mon(i) =sum(npp_loc)*areag2Pg*mondaz(mon)
    i=i+1
  end do
  npp_ts_yr_clmo = cumsum(npp_ts_mon, 0)

;************************************************
; create plot
;************************************************
  data2= new((/4,dimsizes(time)/),float)
  data2(0,:)=npp_ts_yr_default
  data2(1,:)=npp_ts_yr_cent
  data2(2,:)=npp_ts_yr_clm
  data2(3,:)=npp_ts_yr_clmo

 wks   = gsn_open_wks ("pdf","pdfs/nee_rcp45_cts")                ; open workstation
 res   = True
 res@tiMainString     = "Global cumulative NEE (PgC)"            ; add title

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines

 res@xyLineColors = (/"blue","red","green","black"/)  ; 4 different colors

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   =  0.2                ; move units right
  res@pmLegendOrthogonalPosF = -0.95               ; move units down
  res@pmLegendWidthF         = 0.15                ; Change width and
  res@pmLegendHeightF        = 0.18                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .03                 ; label font height
  res@xyExplicitLegendLabels = (/"CENT","CLM","CLMP","CLMO"/)         ; create explicit labels
  res@xyLineThicknesses = (/2.0,2.0,2.0,2.0/)               ;lines thicker
  
 plot  = gsn_csm_xy (wks,time,data2,res) ; create plot




end
