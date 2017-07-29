public class FMSinOsc
{
    SinOsc modulator => Envelope modEnv => SinOsc carrier => Envelope carEnv => dac;
    
    10000 => modulator.gain;
    0.0 => carrier.gain;
    
    2 => carrier.sync;
    
    50 => int modFreq;
    400 => int carFreq;
    25 => int MOD_INCREMENT;
    
    0.05 => float carrierGain;
    0.01 => float GAIN_INCREMENT;
    
    10::ms => dur CARRIER_RAMP => carEnv.duration;
    
    10000 => float ramptime;
    0.85 => float RAMPTIME_INCREMENT;
    
    0 => int isOn;
    
    "FMSinOsc" => string className;
    
    fun void play()
    {
        while (true)
        {
            if (isOn % 2 == 0)
            { 
                break;
            }
            modFreq => modulator.freq;
            carFreq => carrier.freq;
            
            carrierGain => carrier.gain;
            ramptime::ms => modEnv.duration;
            
            1 => carEnv.keyOn;
            CARRIER_RAMP => now;
            
            1 => modEnv.keyOn;
            //<<< "FM duration can NOT be increased", "" >>>;
            ramptime::ms => now;
            1 => modEnv.keyOff;
            //<<< "FM duration CAN be increased", "" >>>;
            ramptime::ms => now;
            
            1 => carEnv.keyOff;
            CARRIER_RAMP => now;
        }
        0.0 => carrier.gain;
    }
    
    fun void turnOn()
    {
        isOn++;
        if (isOn % 2 == 1)
        {
            <<< className+": ON", "" >>>;
            spork ~ play();
        }
        else
        {
            <<< className+": OFF", "" >>>;   
        }
    }
    
    fun string getClassName()
    {
        return className;
    }
    
    fun void increaseGain()
    {
        GAIN_INCREMENT +=> carrierGain;
        <<< "Increase", className, "gain to:", Std.ftoa(carrierGain, 2) >>>;
    }
    
    fun void decreaseGain()
    {
        GAIN_INCREMENT -=> carrierGain;
        if (carrierGain <= 0)
        {
            0 => carrierGain;
        }
        <<< "Decrease", className, "gain to:", Std.ftoa(carrierGain, 2) >>>;
    }
    
    fun void increasePitch()
    {
        MOD_INCREMENT +=> modFreq;
        <<< "Increase", className, "mod. pitch to:", modFreq, "Hz" >>>;
    }
    
    fun void decreasePitch()
    {
        MOD_INCREMENT -=> modFreq;
        if (modFreq <= 25)
        {
            25 => modFreq;
        }
        <<< "Decrease", className, "mod. pitch to:", modFreq, "Hz" >>>;
    }
    
    fun void increaseRamptime()
    {
        RAMPTIME_INCREMENT /=> ramptime;
        <<< "Increase", className, "duration to:", Std.ftoa(ramptime * 2, 0), "ms" >>>;
    }
    
    fun void decreaseRamptime()
    {
        RAMPTIME_INCREMENT *=> ramptime;
        if (ramptime <= 55)
        {
            55 => ramptime;
        }
        <<< "Decrease", className, "duration to:", Std.ftoa(ramptime * 2, 0), "ms" >>>;
    }
}