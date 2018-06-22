**************************************
*** Title: Fighting for a Name on the Ballot
*** Edward Goldring & Michael Wahman
*** Journal: Democratization
**************************************

cd "/Users/edwardgoldring/Dropbox/zambia fieldwork 2016 (1)/Fighting for a Name on the Ballot - May 2017/Replication Files - Fighting for a Name on the Ballot"
use "fighting_for_a_name_democratization_replication", clear


*** Table 2
gen incumbent_time_l = incumbent_time+1
replace incumbent_time_l = ln(incumbent_time_l)

sum bin_Q1_1_2 incumbent_running incumbent_on_pf_list incumbent_on_upnd_list incumbent_time_l pf_or_upnd_not_on_list literacy comp_2015 ethnic_fractionalization pop_density2 violence_history night_light_log, detail
tab bin_Q1_1_2, m
tab incumbent_running, m
tab incumbent_on_pf_list, m
tab incumbent_on_upnd_list, m
tab pf_or_upnd_not_on_list, m
tab violence_history, m


*** Table 3
logit bin_Q1_1_2 comp_2015 pf_or_upnd_not_on_list incumbent_running night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
logit bin_Q1_1_2 comp_2015 incumbent_running night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
logit bin_Q1_1_2 incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)
logit bin_Q1_1_2 pf_or_upnd_not_on_list incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province) 


*** Table 4
qui logit bin_Q1_1_2 incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
predict pr if e(sample)
qui prvalue, x(incumbent_running 0) rest(mean) save
prvalue, x(incumbent_running 1) rest(mean) diff
drop pr
qui logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)
predict pr if e(sample)
qui prvalue, x(incumbent_on_pf_list 0 incumbent_on_upnd_list 0) rest(mean) save
prvalue, x(incumbent_on_pf_list 1 incumbent_on_upnd_list 0) rest(mean) diff
qui prvalue, x(incumbent_on_pf_list 1 incumbent_on_upnd_list 0) rest(mean) save
prvalue, x(incumbent_on_pf_list 1 incumbent_on_upnd_list 1) rest(mean) diff


*** Figure 3
qui logit bin_Q1_1_2 incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
keep if e(sample)

estsimp logit bin_Q1_1_2 incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)


tempname ov
postfile `ov' obs fd1 using "OV Approach1.dta", replace

local i = 1
local end = 156

qui while `i' <= `end' {
	setx [`i']
	
	simqi, fd(prval(1) genpr(fd1)) changex(incumbent_running 0 1)
	
	qui sum fd1
	local fd = r(mean)
	
	if mod(`i',50) == 0 {
		nois display "." _c
		if mod(`i',1000) == 0 {
			nois display ""
		}
	}
	
	post `ov' (`i') (`fd')
	drop fd1
	local i = `i' + 1
}

postclose `ov'

preserve
	use "OV Approach1.dta", clear
	
	sum fd1, det
	qui hist fd1, xtitle("FD of Incumbent (0 to 1)") scheme(s1mono) xline(-.13, lpattern(dash)) name(ov1, replace)
restore

*** Changing PF incumbent running from 0 to 1
use "fighting_for_a_name_democratization_replication", clear

qui logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)
keep if e(sample)

estsimp logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)

tempname ov
postfile `ov' obs fd1 using "OV Approach2.dta", replace

local i = 1
local end = 156

qui while `i' <= `end' {
	setx [`i']
	
	simqi, fd(prval(1) genpr(fd1)) changex(incumbent_on_pf_list 0 1)
	
	qui sum fd1
	local fd = r(mean)
	
	if mod(`i',50) == 0 {
		nois display "." _c
		if mod(`i',1000) == 0 {
			nois display ""
		}
	}
	
	post `ov' (`i') (`fd')
	drop fd1
	local i = `i' + 1
}

postclose `ov'

preserve
	use "OV Approach2.dta", clear
	
	sum fd1, det
	qui hist fd1, xtitle("FD of PF Incumbent (0 to 1)") scheme(s1mono) xline(-.16, lpattern(dash)) name(ov2, replace)
restore

*** Changing UPND incumbent running from 0 to 1
use "fighting_for_a_name_democratization_replication", clear

qui logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)
keep if e(sample)

estsimp logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(province)

tempname ov
postfile `ov' obs fd1 using "OV Approach3.dta", replace

local i = 1
local end = 156

qui while `i' <= `end' {
	setx [`i']
	
	simqi, fd(prval(1) genpr(fd1)) changex(incumbent_on_upnd_list 0 1)
	
	qui sum fd1
	local fd = r(mean)
	
	if mod(`i',50) == 0 {
		nois display "." _c
		if mod(`i',1000) == 0 {
			nois display ""
		}
	}
	
	post `ov' (`i') (`fd')
	drop fd1
	local i = `i' + 1
}

postclose `ov'

preserve
	use "OV Approach3.dta", clear
	
	sum fd1, det
	qui hist fd1, xtitle("FD of UPND Incumbent (0 to 1)") scheme(s1mono) xline(-.03, lpattern(dash)) name(ov3, replace)
restore

*** Graphing the observed values graphs together
graph combine ov1 ov2 ov3, cols(2) scheme(s1mono)
graph export ov_dem.pdf, replace


*** Figure 4
qui logit bin_Q1_1_2 comp_2015 pf_or_upnd_not_on_list incumbent_running night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)
predict pr if e(sample)
twoway lfitci pr pop_density2, level(95) ciplot(rline) xtitle("Population Density") ytitle("Pr(y=Nomination violence)") scheme(s1mono) yline(0, lpattern(dash)) name(twoway, replace)


*** Online Appendix: Table 6
logit bin_Q1_1_2 comp_2015 pf_or_upnd_not_on_list incumbent_running night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(district)
logit bin_Q1_1_2 comp_2015 incumbent_running night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(district)
logit bin_Q1_1_2 incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(district)
logit bin_Q1_1_2 incumbent_on_pf_list incumbent_on_upnd_list night_light_log violence_history literacy comp_2015 ethnic_fractionalization pop_density2, cluster(district)
logit bin_Q1_1_2 comp_2015 incumbent_time inc_2 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(district)
logit bin_Q1_1_2 pf_or_upnd_not_on_list incumbent_running comp_2015 night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(district) 


*** Online Appendix: Table 7
gen incumbent_time_l = incumbent_time+1
replace incumbent_time_l = ln(incumbent_time_l)
logit bin_Q1_1_2 comp_2015 incumbent_time_l night_light_log violence_history literacy ethnic_fractionalization pop_density2, cluster(province)


*** Online Appendix: Figure 5
drop pr
predict pr if e(sample)
twoway lfitci pr incumbent_time_l, level(95) ciplot(rline) xtitle("Incumbent (years) - log") ytitle("Pr(y=Nomination violence)") scheme(s1mono)



