set ns [new Simulator]
set trFile [open out1.tr w]
$ns trace-all $trFile
set namFile [open out1.nam w]
$ns namtrace-all $namFile

# Create the nodes:
set client1 [$ns node]
set router1 [$ns node]
set server [$ns node]

# Name the nodes:
$ns at 0.0 "$client1 label client1"
$ns at 0.0 "$router1 label router1"
$ns at 0.0 "$server label Endserver"

# Give shape to the nodes:
$client1 shape circle
$router1 shape square
$server  shape hexagon

# Create the links:
$ns duplex-link $client1 $router1 2Mb 100ms DropTail
$ns duplex-link $router1 $server  2Mb 100ms DropTail

# Orintation for the links:
$ns duplex-link-op $client1 $router1 orient right
$ns duplex-link-op $router1 $server  orient right

# Create a TCP agent and attach it to node client1:
set tcp1 [new Agent/TCP]
$ns attach-agent $client1 $tcp1

# Create the FTP APP and attach it to node tcp1:
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

# Create the sink:
set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $router1 $tcpsink1
$ns connect $tcp1 $tcpsink1


set tcp2 [new Agent/TCP]
$ns attach-agent $router1 $tcp2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

# Create the sink:
set tcpsink2 [new Agent/TCPSink]
$ns attach-agent $server $tcpsink2
$ns connect $tcp2 $tcpsink2


$tcp1 set class_ 1
$tcp2 set class_ 2

$ns color 1 Green
$ns color 2 Blue


proc finish {} {
	global ns trFile namFile
	$ns flush-trace
	close $trFile
	close $namFile
	exec nam out1.nam
	exit 0
}


$ns at 0.5 "$ftp1 start"
$ns at 3.5 "$ftp1 stop"
$ns at 0.5 "$ftp2 start"
$ns at 3.5 "$ftp2 stop"
$ns at 4.0 "finish"

$ns run
