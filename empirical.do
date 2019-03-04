clear
capture log close
capture log using "empirical.log", replace text
cd "C:\Users\ery1\Downloads"
set more off
import excel "C:\Users\ery1\Downloads\approval_toplineX.xlsx", sheet("approval_topline")
*delete the top row of text and rename the variables*
rename A president
rename B subgroup
rename C date
rename D approval
rename J shutdown
rename K postshutdown
rename L preshutdown
rename M lengthshutdown
rename N lengthpost
rename O stocks
*get rid of names at the top*
drop in 1
*only interested in data since 7/1/2018 but includes post-shutdown data*
*maybe we want to code post-shutdown data as 1, since it had happened*
*question of if we want to include post shutdown data???*
drop in 233/756
*they were being stored as string variables so you have to detring*
*see if there is a way to destring all at once*
destring(approval), replace
destring(shutdown), replace
destring(postshutdown), replace
destring(preshutdown), replace
destring(lengthshutdown), replace
destring(lengthpost), replace
destring(stocks), replace
*look at average approval since the beginning of July*
summ approval
*look at approval DURING shutdown*
summ approval if shutdown>=1
*look at approval only BEFORE shutdown*
summ approval if preshutdown>=1
*look at approval only AFTER shutdown*
summ approval if postshutdown>=1

*regress approval on if the government was shutdown or not*
reg approval shutdown, r

*regress approval on if the government was shutdown AND if the government had been shutdown*
*pre shutdown mean implicit in constant*
reg approval shutdown postshutdown, r
*a ttest measuring the difference in approval based on shutdown yields significant results*
ttest approval, by(shutdown)


*we can also investigate the length of the shutdown*
reg approval shutdown postshutdown lengthshutdown lengthpost, r

*incorporate stock info*
summ stocks if shutdown>=1
summ stocks if preshutdown>=1
summ stocks if postshutdown>=1

*stock prices were significantly different during and after the shutdown)
ttest stocks, by(preshutdown)

*simple regression shows that stock prices did not have a significant effect*
reg approval stocks, r

*multivalued regressions showed that higher stock prices negatively affected approval*
reg approval shutdown postshutdown lengthshutdown lengthpost stocks, r

ssc install estout, replace
esttab using approval.rtf, se r2 ar2 scalar(rmse) replace
