* Author: Anshul Satav
* Final Project SVAR Model
* Acknowledgement: I used ChatGPT in some parts

insheet using "C:\Users\anshu\OneDrive - Grinnell College\ts_anshul_data.csv", clear

gen time = _n
tsset time

* observing the trends
tsline nqrobous
tsline djusen
tsline cels

* saving the original data to use later for corecast comparisons
save "C:\Users\anshu\Downloads\original.dta",replace

* separating the training and testing data
keep if tin(1,1005)

label var nqrobous_ind "NASDAQ AI and Robotics Index U.S."
label var djusen_ind "Dow Jones U.S. Oil and Gas Index"
label var sp500_ind "S&P Global 500 Market Index"
label var dff "Daily Effective Federal Funds Rate"
label var cels_ind "NASDAQ Clean Edge Energy Index"

bro

* checking for stationarity 
dfuller nqrobous, trend lags(10)
dfuller cels, trend lags(10)
dfuller djusen, trend lags(10)
dfuller dff, trend lags(10)
dfuller sp500, trend lags(10)

* cointegration test 
vecrank nqrobous cels djusen dff sp500, max

* Finding the suggested number of lags for the model
varsoc nqrobous cels djusen dff sp500


* specifying the short run restrcition matrix

matrix A = (1,0,0,0,0 \ .,1,0,0,0 \ .,.,1,0,0 \ .,.,.,1,0 \ .,.,.,.,1)
matrix B = (.,0,0,0,0 \ 0,.,0,0,0 \ 0,0,.,0,0 \ 0,0,0,.,0 \ 0,0,0,0,.)	

* main model
svar djusen cels nqrobous sp500 dff, lags(1) aeq(A) beq(B)

* generating irfs combined
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(cels_ind djusen_ind nqrobous_ind sp500_ind dff_ind) response (nqrobous_ind) byopt(yrescale)
	
* generating individual irfs 	
irf set myirf, replace
irf create svar_model

* Figure 2
irf graph sirf, impulse(cels_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in NASDAQ Clean Edge Energy Index (CELS)") ciopts(color(%60)) 
* Figure 4	
irf graph sirf, impulse(djusen_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in Dow Jones U.S. Oil and Gas Index (DJUSEN)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))


* Figure 3
irf graph sirf, impulse(nqrobous_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in NASDAQ CTA AI and Robotics U.S. Index (NQROBOUS)") ciopts(color(%60)) 

* A1
irf graph sirf, impulse(cels_ind djusen_ind nqrobous_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))
	
	
	
* generating fevds
* A2
irf graph fevd, impulse(cels_ind djusen_ind sp500_ind dff_ind nqrobous_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))
 
* Figure 5
irf graph fevd, impulse(cels_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in NASDAQ Clean Edge Energy Index (CELS)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))


* Figure 7
irf graph fevd, impulse(djusen_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in Dow Jones U.S. Oil and Gas Index (DJUSEN)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))

* Figure 6
irf graph fevd, impulse(nqrobous_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in NASDAQ CTA AI and Robotics U.S. Index (NQROBOUS)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))


* robustness checks

* switching ordering 
* A5
svar cels djusen nqrobous sp500 dff, lags(1) aeq(A) beq(B) 

* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))


* A4
svar djusen nqrobous cels sp500 dff, lags(1) aeq(A) beq(B)

* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))

* A3
svar cels nqrobous djusen sp500 dff, lags(1) aeq(A) beq(B)
* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))

* A6
svar nqrobous djusen cels sp500 dff, lags(1) aeq(A) beq(B)
* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))

* Figure 8
irf graph sirf, impulse(cels_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in NASDAQ Clean Edge Energy Index (CELS)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black)) 
* Figure 10	
irf graph sirf, impulse(djusen_ind) response(nqrobous_ind) ytitle("AI and Robotics Index") title("Shock in Dow Jones U.S. Oil and Gas Index (DJUSEN)") ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))

* A7
svar nqrobous cels djusen sp500 dff, lags(1) aeq(A) beq(B)
* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) ciopts(color(%60)) yline(0, lwidth(thick) lcolor(black))


* more lags
* 2 lags
* A9
svar djusen cels nqrobous sp500 dff, lags(1/2) aeq(A) beq(B)
* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) yline(0, lwidth(thick) lcolor(black)) ciopts(color(%60))

* A10
* 3 lags
svar djusen cels nqrobous sp500 dff, lags(1/3) aeq(A) beq(B)
* generating irfs
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(djusen_ind nqrobous_ind cels_ind sp500_ind dff_ind) response(nqrobous_ind) byopt(yrescale) yline(0, lwidth(thick) lcolor(black)) ciopts(color(%60))


* A8
* excluding macroeconomic variables 
matrix A = (1,0,0\ .,1,0 \ .,.,1 )
matrix B = (.,0,0 \ 0,.,0 \ 0,0,.)
			
svar djusen cels nqrobous, lags(1) aeq(A) beq(B)
irf set myirf, replace
irf create svar_model
irf graph sirf, impulse(cels_ind djusen_ind nqrobous_ind) ///
    response(nqrobous_ind)  byopt(yrescale) yline(0, lwidth(thick) lcolor(black)) ciopts(color(%60))

matrix A = (1,0,0,0,0 \ .,1,0,0,0 \ .,.,1,0,0 \ .,.,.,1,0 \ .,.,.,.,1)
			
matrix B = (.,0,0,0,0 \ 0,.,0,0,0 \ 0,0,.,0,0 \ 0,0,0,.,0 \ 0,0,0,0,.)	

svar djusen cels nqrobous sp500 dff, lags(1) aeq(A) beq(B)

* forecasting for 2025
fcast compute f_, step(250)

* saving forecasts to merge later 
keep time f_nqrobous_ind f_nqrobous_ind_lb f_nqrobous_ind_ub
save forecasts.dta, replace

* importing the original data back to show forecast comparison
use "C:\Users\anshu\Downloads\original.dta", clear
tsset time

* merging the forecasts data
merge 1:1 time using forecasts.dta

* calculating the rmse 
gen error = nqrobous - f_nqrobous_ind if time > 1005
gen sq_error = error^2
summ sq_error
display sqrt(r(mean))

* calculating the mae
gen abs_error = abs(nqrobous - f_nqrobous_ind)
summ abs_error
display r(mean)



* graphing the forecasts vs actual values
* Figure 12
gen date3 = date(date, "YMD")
format date3 %tdCCYY-NN
tsset date3

twoway ///
(rarea f_nqrobous_ind_ub f_nqrobous_ind_lb date3 if time > 1005, ///
    fcolor(gs12%40) lcolor(gs12%40)) ///
(line nqrobous_ind date3 if time > 1005, lcolor(blue)) ///
(line f_nqrobous_ind date3 if time > 1005, lcolor(red)) ///
, ///
title("Forecast(Red) vs Actual(Blue) for AI Index") ///
xtitle("Date") ///
legend(order(2 "Actual" 3 "Forecast" 1 "95% CI"))
