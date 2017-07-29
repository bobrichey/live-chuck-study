/*
Program:
Name: Bob Richey
Date: 1/4/2015
*/

Hid hid;

HidMsg msg;

0 => int device;

if (hid.openKeyboard(device) == false) me.exit();

<<< "msg.asciiboard:", hid.name(), "ready!" >>>;

// UGens

SinOscClusters sinClusters;
SqrOscClusters sqrClusters;
FMSinOsc fm;
ImpulseDelay impDelay;

// TODO

string editUGen;

// MAIN LOOP

while (true)
{
    hid => now;
    
    while (hid.recv(msg))
    {
        if (msg.isButtonDown()) 
        {    
            if (msg.ascii == 90) // Z
            {
                sinClusters.turnOn();
            } 
            else if (msg.ascii == 88) // X
            {
                sqrClusters.turnOn();
            } 
            else if (msg.ascii == 67) // C
            {
                fm.turnOn();
            }
            else if (msg.ascii == 86) // V
            {
                impDelay.turnOn();
            }
            else if (msg.ascii == 65) // A
            {
                setUGen(sinClusters.getClassName());
            }
            else if (msg.ascii == 83) // S
            {
                setUGen(sqrClusters.getClassName());
            }
            else if (msg.ascii == 68) // D
            {
                setUGen(fm.getClassName());
            }
            else if (msg.ascii == 70) // F
            {
                setUGen(impDelay.getClassName());
            }
            else if (msg.ascii == 75) // K
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.increaseGain();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.increaseGain();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.increaseGain();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.increaseGain();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else if (msg.ascii == 44) // COMMA(,)
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.decreaseGain();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.decreaseGain();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.decreaseGain();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.decreaseGain();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else if (msg.ascii == 76) // L
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.increaseRamptime();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.increaseRingtime();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.increaseRamptime();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.increaseTempo();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else if (msg.ascii == 46) // PERIOD(.)
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.decreaseRamptime();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.decreaseRingtime();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.decreaseRamptime();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.decreaseTempo();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else if (msg.ascii == 59) // SEMICOLON(;)
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.increasePitch();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.increasePitch();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.increasePitch();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.increasePitch();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else if (msg.ascii == 47) // FORWARD SLASH(/)
            {
                if (editUGen == sinClusters.getClassName())
                {
                    sinClusters.decreasePitch();
                }
                else if (editUGen == sqrClusters.getClassName())
                {
                    sqrClusters.decreasePitch();
                }
                else if (editUGen == fm.getClassName())
                {
                    fm.decreasePitch();
                }
                else if (editUGen == impDelay.getClassName())
                {
                    impDelay.decreasePitch();
                }
                else
                {
                    errorMessage(1);
                }
            }
            else
            {
                errorMessage(0);
            }
        }
    }
}

fun void setUGen(string ugen)
{
    ugen => editUGen;
    <<< "EDITING:", editUGen, "" >>>;
}

fun void errorMessage(int errorNumber)
{
    if (errorNumber == 1)
    {
        <<< "ERROR: NO UGEN SELECTED", "" >>>;
    }
    else
    {
        <<< "ERROR: INVALID INPUT", msg.ascii >>>;
    }
}