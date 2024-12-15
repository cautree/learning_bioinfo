BEGIN {

      FS= "|"
      printf "%50s\n",  "Basic  DA  HRA Gross"

} /sale|marketing/ {

    da = 0.25*$6
    hra = 0.5*$6
    gross = $6 + hra + da

    tot[1] += $6
    tot[2] += da
    tot[3] += hra
    tot[4] += gross

    c++


} 
END {

 printf "\t Average %5d %5d %5d %5d\n", tot[1]/c, tot[2]/c, tot[3]/c, tot[4]/c 

}