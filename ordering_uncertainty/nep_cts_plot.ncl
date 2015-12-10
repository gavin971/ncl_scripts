;
;plot gpp ts_data
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************
begin
;*******************************************
  g2Pg=1.e-15
  km2tom2=1.e6
  areag2Pg=g2Pg*km2tom2*86400.
  mondaz=(/31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31./)
  tscal=86400.*365.;   total number of seconds per year
  time=fspan(1850,2000,151*12)
;*******************************************
; read files
;*******************************************
  mother_dir="/Users/jinyuntang/work/data_collection/clm_output/acme_output/nambiguity/"
;************************************************
; load area
;************************************************
  file_name=str_concat((/mother_dir,"area_1.9x2.5.nc"/))
  grid_in=addfile(file_name,"r")
  area=grid_in->area

;************************************************
; read default carbon flux
;************************************************

  child_dir="1850-2000/default_derive/"
  stem_name="carbon_flux"
  postfixer=".1850-2000.nc"
  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEP

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
  child_dir="1850-2000/betr_cent_derive/"

  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEP
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
  child_dir="1850-2000/betr_clm_derive/"

  file_name=str_concat((/mother_dir,child_dir,stem_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->NEP
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
; create plot
;************************************************
  data2= new((/3,dimsizes(time)/),float)
  data2(0,:)=npp_ts_yr_default
  data2(1,:)=npp_ts_yr_cent
  data2(2,:)=npp_ts_yr_clm

 wks   = gsn_open_wks ("ps","nep_cts")                ; open workstation
 res   = True
 res@tiMainString     = "Global NEP (PgC)"            ; add title

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines

 res@xyLineColors = (/"blue","red","green"/)  ; 3 different colors
 res@xyExplicitLegendLabels = (/"BGC default","BGC New-1","BGC New-2"/)

 res@pmLegendDisplayMode    = "Always"   ; Display a legend.
 res@lgPerimOn              = False      ; No legend perimeter.
 res@pmLegendOrthogonalPosF = -0.01      ; Move closer to plot
 res@lgLabelFontHeightF     = .015                 ; change font height

 plot  = gsn_csm_xy (wks,time,data2,res) ; create plot



end
