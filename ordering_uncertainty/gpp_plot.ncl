;
; * gpp_plot.ncl
; * 
; *
; * Created by Jinyun Tang on 11/24/15.
; * Copyright 2015 __MyCompanyName__. All rights reserved.
; 

;
;plot gpp data
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************
begin
;*******************************************
  mother_dir="/Users/jinyuntang/work/data_collection/clm_output/acme_output/nambiguity/1850-2000/"
  child_dir="default/"
  var_name="GPP"
  postfixer="-1850-2000.nc"
  file_name=str_concat((/mother_dir,child_dir,var_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  npp=cn_flx_in->GPP
  tscal=86400.*365.;   total number of seconds per year
  npp_annual_mean=dim_avg_n(npp(1692:,:,:),0)*tscal;  temporal average
  npp_annual_mean@_FilleValue=npp@_FillValue
  npp_annual_mean@long_name="Annual GPP (gC/m2)"
  npp_annual_mean@coordinates="lat lon"
  npp_annual_mean!0="lat"
  npp_annual_mean!1="lon"
  npp_annual_mean@lat=cn_flx_in->lat 
  npp_annual_mean@lon=cn_flx_in->lon
  lon=cn_flx_in->lon
  lat=cn_flx_in->lat
  npp_annual_mean&lat=lat
  npp_annual_mean&lon=lon
  npp_annual_mean&lat@units="degrees_north"
  npp_annual_mean&lon@units="degrees_east"
;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("ps","gpp")               ; open a ncgm file
  gsn_define_colormap(wks,"gui_default")        ; select color map
  res = True                                    ; plot mods desired
  res@gsnSpreadColors      = True               ; make cn span entire color map

  res@mpFillOn             = False              ; turn off gray continents
  res@cnFillOn             = True               ; turn on color fill

  plot = gsn_csm_contour_map_ce(wks,npp_annual_mean, res)   ; create plot
end


