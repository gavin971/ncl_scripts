;*
; * cflux_plot_lat.ncl
; * 
; *
; * Created by Jinyun Tang on 11/24/15.
; * Copyright 2015 __MyCompanyName__. All rights reserved.
; *
;

;plot latitudinal data
;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************
begin
;*******************************************
  mother_dir="/Users/JinyunTang/data_mirror/RCP45/"
  f_name="carbon_flux.RCP45."
  postfixer="2001-2300.nc"
  tscal=86400.*365.;   total number of seconds per year

  nyr=50
  t1=0+nyr*12
  t2=t1+12*10-1
  var_name="NEE"
  outyr=nyr+2000
  outyr_string=tostring_with_format(outyr,"%4.4d")
  fig_name=str_concat((/"pdfs/",var_name,"_lat_",outyr_string/))
  
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
  else if(var_name .eq. "NEE")
    data3d = cn_flx_in->NEE
  end if
  end if
  end if	
  end if
  end if


  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue
  data_annual_mean@long_name=str_concat((/var_name," (gC/m2/yr)"/))
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

  data_lat_avg_cent=dim_avg_n(data_annual_mean,1)
;************************************************
; read betr_cent
;************************************************
  delete(cn_flx_in)
  delete(data3d)
  delete(data_annual_mean)
  
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
  else if(var_name .eq. "NEE")
    data3d = cn_flx_in->NEE
  end if    
  end if	
  end if		
  end if
  end if

  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue

  data_lat_avg_clmo=dim_avg_n(data_annual_mean,1)

;************************************************
; read betr_clm
;************************************************
  delete(cn_flx_in)
  delete(data3d)
  delete(data_annual_mean)

  child_dir="betr_clm3_derive/"
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
  else if(var_name .eq. "NEE")
    data3d = cn_flx_in->NEE
  end if    
  end if	
  end if		
  end if
  end if

  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue

  data_lat_avg_clm3=dim_avg_n(data_annual_mean,1)
  
;************************************************
; read betr_clm
;************************************************
  delete(cn_flx_in)
  delete(data3d)
  delete(data_annual_mean)
  child_dir="betr_clm_derive/"

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
  else if(var_name .eq. "NEE")
    data3d = cn_flx_in->NEE
  end if    
  end if	
  end if		
  end if
  end if

  data_annual_mean=dim_avg_n(data3d(t1:t2,:,:),0)*tscal;  temporal average
  data_annual_mean@_FilleValue=data3d@_FillValue

  data_lat_avg_clm=dim_avg_n(data_annual_mean,1)
  

;************************************************
; create plot
;************************************************
data2= new((/4,dimsizes(lat)/),float)
data2(0,:)=data_lat_avg_cent
data2(1,:)=data_lat_avg_clmo
data2(2,:)=data_lat_avg_clm3
data2(3,:)=data_lat_avg_clm
wks   = gsn_open_wks ("pdf",fig_name)                ; open workstation
res   = True
res@xyDashPattern = 0               ; Make curves all solid
res@xyLineColors   =  (/"blue","red","green","black"/)

res@tiMainString     = str_concat((/var_name," (gC/m2/yr)"/))            ; add title

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   =  0.2                ; move units right
  res@pmLegendOrthogonalPosF = -0.45               ; move units down
  res@pmLegendWidthF         = 0.15                ; Change width and
  res@pmLegendHeightF        = 0.18                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .03                 ; label font height
  res@xyExplicitLegendLabels = (/"CENT","CLMO","CLM3","CLM"/)         ; create explicit labels
  res@xyLineThicknesses = (/2.0,2.0,2.0,2.0/)               ;lines thicker
  
plot  = gsn_csm_xy (wks,lat,data2,res) ; create plot
end

