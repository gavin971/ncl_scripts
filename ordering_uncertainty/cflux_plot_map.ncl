; *
; * gpp_plot_map.ncl
; * 
; *
; * Created by Jinyun Tang on 11/24/15.
; * Copyright 2015 __MyCompanyName__. All rights reserved.
; *

;
;plot gpp data
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************
begin
  mother_dir="/Users/JinyunTang/data_mirror/RCP45/"
  nyr=150
  t1=0+nyr*12
  t2=t1+12*10-1
  var_name="HR"
  f_name="carbon_flux.RCP45."
  postfixer="2001-2300.nc"
  tscal=86400.*365.;   total number of seconds per year
  outyr=nyr+2000
  outyr_string=tostring_with_format(outyr,"%4.4d")
  fig_name=str_concat((/"pdfs/",var_name,"-",outyr_string/))
;*******************************************
  child_dir="betr_cent_derive/"
  file_name=str_concat((/mother_dir,child_dir,f_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  
  ;input the right data
  if( var_name .eq. "GPP")
    data3d =cn_flx_in->GPP
  else if(var_name .eq. "NEP")
    data3d = cn_flx_in->NEP
  else if(var_name .eq. "NPP")
    data3d = cn_flx_in->NPP	
  else if(var_name .eq. "HR")
    data3d = cn_flx_in->HR
  end if
  end if	
  end if
  end if

  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue
  data_annual_mean@long_name=str_concat((/"Annual ",var_name," (gC/m2)"/))
  data_annual_mean@coordinates="lat lon"
  data_annual_mean!0="lat"
  data_annual_mean!1="lon"
  data_annual_mean@lat=cn_flx_in->lat 
  data_annual_mean@lon=cn_flx_in->lon
  lon=cn_flx_in->lon
  lat=cn_flx_in->lat
  data_annual_mean&lat=lat
  data_annual_mean&lon=lon
  data_annual_mean&lat@units="degrees_north"
  data_annual_mean&lon@units="degrees_east"
  
  
;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("pdf",fig_name)               ; open a ncgm file
  gsn_define_colormap(wks,"gui_default")        ; select color map
  res = True                                    ; plot mods desired
  res@gsnSpreadColors      = True               ; make cn span entire color map
  res@gsnFrame             = False              ; do not advance
  res@mpFillOn             = False              ; turn off gray continents
  res@cnFillOn             = True               ; turn on color fill
  res@vpXF                 = 0.1
  res@vpYF                 = 0.99
  res@vpWidthF             = 0.35
  res@vpHeightF            = 0.35
  res@cnLinesOn            = False 
  
  ;res@cnLevelSelectionMode = "ManualLevels"
  ;res@cnMinLevelValF       = 0
  ;res@cnMaxLevelValF       = 3000
  ;res@cnLevelSpacingF      = 500
  plot1 = gsn_csm_contour_map_ce(wks,data_annual_mean, res)   ; create plot
;************************************************
; create second plot
;************************************************
  delete(data_annual_mean)
  delete(data3d)
  
  child_dir="betr_clmo_derive/"
  file_name=str_concat((/mother_dir,child_dir,f_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  
  ;input the right data  
  if( var_name .eq. "GPP")
    data3d = cn_flx_in->GPP
  else if(var_name .eq. "NEP")
    data3d = cn_flx_in->NEP
  else if(var_name .eq. "NPP")
    data3d = cn_flx_in->NPP
  else if(var_name .eq. "HR")
    data3d = cn_flx_in->HR
  end if	
  end if		
  end if
  end if
  
  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue
  data_annual_mean@long_name=str_concat((/"Annual ",var_name," (gC/m2)"/))
  data_annual_mean@coordinates="lat lon"
  data_annual_mean!0="lat"
  data_annual_mean!1="lon"
  data_annual_mean@lat=cn_flx_in->lat 
  data_annual_mean@lon=cn_flx_in->lon
  lon=cn_flx_in->lon
  lat=cn_flx_in->lat
  data_annual_mean&lat=lat
  data_annual_mean&lon=lon
  data_annual_mean&lat@units="degrees_north"
  data_annual_mean&lon@units="degrees_east"  
  sres = True                                    ; plot mods desired
  sres@gsnSpreadColors      = True               ; make cn span entire color map
  sres@gsnFrame             = False              ; do not advance
  sres@mpFillOn             = False              ; turn off gray continents
  sres@cnFillOn             = True               ; turn on color fill
  sres@vpXF                 = 0.1
  sres@vpYF                 = 0.7
  sres@vpWidthF             = 0.35
  sres@vpHeightF            = 0.35
  sres@cnLinesOn            = False 
  plot2 = gsn_csm_contour_map_ce(wks,data_annual_mean, sres)   ; create plot  
  

;************************************************
; create third plot
;************************************************
  delete(data_annual_mean)
  delete(data3d)
  
  child_dir="betr_clm3_derive/"
  postfixer="2001-2300.nc"
  file_name=str_concat((/mother_dir,child_dir,f_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  
  ;input the right data
  if( var_name .eq. "GPP")
    data3d =cn_flx_in->GPP
  else if(var_name .eq. "NEP")
    data3d = cn_flx_in->NEP
  else if(var_name .eq. "NPP")
    data3d = cn_flx_in->NPP
  else if(var_name .eq. "HR")
    data3d = cn_flx_in->HR
  end if	
  end if		
  end if
  end if
  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue
  data_annual_mean@long_name=str_concat((/"Annual ",var_name," (gC/m2)"/))
  data_annual_mean@coordinates="lat lon"
  data_annual_mean!0="lat"
  data_annual_mean!1="lon"
  data_annual_mean@lat=cn_flx_in->lat 
  data_annual_mean@lon=cn_flx_in->lon
  lon=cn_flx_in->lon
  lat=cn_flx_in->lat
  data_annual_mean&lat=lat
  data_annual_mean&lon=lon
  data_annual_mean&lat@units="degrees_north"
  data_annual_mean&lon@units="degrees_east"  
  tres = True                                    ; plot mods desired
  tres@gsnSpreadColors      = True               ; make cn span entire color map
  tres@gsnFrame             = False              ; do not advance
  tres@mpFillOn             = False              ; turn off gray continents
  tres@cnFillOn             = True               ; turn on color fill
  tres@vpXF                 = 0.6
  tres@vpYF                 = 0.99
  tres@vpWidthF             = 0.35
  tres@vpHeightF            = 0.35
  tres@cnLinesOn            = False
  
  plot3 = gsn_csm_contour_map_ce(wks,data_annual_mean, tres)   ; create plot  
  

;************************************************
; create fourth plot
;************************************************
  delete(data_annual_mean)
  delete(data3d)
  child_dir="betr_clm_derive/"
  file_name=str_concat((/mother_dir,child_dir,f_name,postfixer/))
  cn_flx_in=addfile(file_name,"r");  pointer to file
  
  ;input the right data
  if( var_name .eq. "GPP")
    data3d =cn_flx_in->GPP
  else if(var_name .eq. "NEP")
    data3d = cn_flx_in->NEP
  else if(var_name .eq. "NPP")
    data3d = cn_flx_in->NPP
  else if(var_name .eq. "HR")
    data3d = cn_flx_in->HR
  end if	
  end if		
  end if
  end if
  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue
  data_annual_mean@long_name=str_concat((/"Annual ",var_name," (gC/m2)"/))
  data_annual_mean@coordinates="lat lon"
  data_annual_mean!0="lat"
  data_annual_mean!1="lon"
  data_annual_mean@lat=cn_flx_in->lat 
  data_annual_mean@lon=cn_flx_in->lon
  lon=cn_flx_in->lon
  lat=cn_flx_in->lat
  data_annual_mean&lat=lat
  data_annual_mean&lon=lon
  data_annual_mean&lat@units="degrees_north"
  data_annual_mean&lon@units="degrees_east"  
  fres = True                                    ; plot mods desired
  fres@gsnSpreadColors      = True               ; make cn span entire color map
  fres@gsnFrame             = False              ; do not advance
  fres@mpFillOn             = False              ; turn off gray continents
  fres@cnFillOn             = True               ; turn on color fill
  fres@vpXF                 = 0.6
  fres@vpYF                 = 0.7
  fres@vpWidthF             = 0.35
  fres@vpHeightF            = 0.35
  fres@cnLinesOn            = False 
  plot4 = gsn_csm_contour_map_ce(wks,data_annual_mean, fres)   ; create plot  	  
  
end


