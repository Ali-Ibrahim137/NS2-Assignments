set ns [new Simulator]
set trFile [open out.tr w]
$ns trace-all $trFile
set namFile [open out.nam w]
$ns namtrace-all $namFile

# Create the nodes:
set client1 [$ns node]
set client2 [$ns node]
set router1 [$ns node]
set router2 [$ns node]
set server [$ns node]

# Name the nodes:
$ns at 0.0 "$client1 label client1"
$ns at 0.0 "$client2 label client2"
$ns at 0.0 "$router1 label router1"
$ns at 0.0 "$router2 label router2"
$ns at 0.0 "$server label server"

# Give shape to the nodes:
$client1 shape circle
$client2 shape circle
$router1 shape box
$router2 shape box
$server  shape hexagon

# Create the links:
$ns duplex-link $client1 $router1 2Mb 100ms DropTail
$ns duplex-link $client2 $router1 2Mb 100ms DropTail
$ns duplex-link $router1 $router2 2Mb 100ms DropTail
$ns duplex-link $router2 $server 200Kb 100ms DropTail

# Orintation for the links:
$ns duplex-link-op $client1 $router1 orient down
$ns duplex-link-op $client2 $router1 orient right
$ns duplex-link-op $router1 $router2 orient right
$ns duplex-link-op $router2 $server  orient down

# Create a UDP agent and attach it to node client1:
set tcp1 [new Agent/TCP]
$tcp1 tracevar cwnd_ 16
$ns attach-agent $client1 $tcp1

# Create the FTP APP and attach it to node tcp1:
set ftp1 [new Application/FTP]
$ftp1 set packetSize_ 1000
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$tcp2 tracevar cwnd_ 16
$ns attach-agent $client2 $tcp2

set ftp2 [new Application/FTP]
$ftp2 set packetSize_ 1000
$ftp2 attach-agent $tcp2


# Create the sink:
set tcpsink [new Agent/TCPSink]
$ns attach-agent $server $tcpsink
$ns connect $tcp1 $tcpsink
$ns connect $tcp2 $tcpsink


$tcp1 set class_ 1
$tcp2 set class_ 2

$ns color 1 Green
$ns color 2 Blue


proc finish {} {
	global ns trFile namFile
	$ns flush-trace
	close $trFile
	close $namFile
	exec nam out.nam
	exit 0
}


$ns at 0.5 "$ftp1 start"
$ns at 0.5 "$ftp2 start"
$ns at 5.5 "$ftp1 stop"
$ns at 5.5 "$ftp2 stop"
$ns at 6.0 "finish"

$ns run
