// class files
Machine.add(me.dir() + "/SinOscClusters.ck");
Machine.add(me.dir() + "/SqrOscClusters.ck");
Machine.add(me.dir() + "/FMSinOsc.ck");
Machine.add(me.dir() + "/ImpulseDelay.ck");

1::ms => now;

// HID file
Machine.add(me.dir() + "/keyboard map.ck");

/*
Controls:

Z - SinOscClusters on/off
A - Edit SinOscClusters

X - SqrOscClusters on/off
S - Edit SqrOscClusters

C - FMSinOsc on/off
D - Edit FMSinOsc

V - ImpulseDelay on/off
F - Edit ImpulseDelay

K - Increase gain of selected class
, - Decrease gain of selected class

L - Increased duration of selected class
. - Decreased duration of selected class

; - Increase frequency (Hz) of selected class
/ - Decrease frequency (Hz) of selected class
*/