BEGIN {    printf "SlNo \t Name \t\t Salary\n"
} 
$6>7500{
    count++
    total += $6
    printf "%3d %-20s %d\n", count, $2, $6
} END{
    printf "\nThe average salary is: %d\n", total/count
    }