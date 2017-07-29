public class SqrOscClusters
{
    3 => int NUM_VOICES;
    
    TriOsc sqr[NUM_VOICES];
    Envelope env[NUM_VOICES];
    Pan2 pan[NUM_VOICES];
    Envelope env2;
        
    float panning;
    
    0.16 => float minGain;
    0.18 => float maxGain;
    0.02 => float GAIN_INCREMENT;
    
    50 => float minFreq;
    200 => float maxFreq;
    1.5 => float PITCH_INCREMENT;
    
    60 => int ringtime;
    60 => int RAMPTIME;
    20 => int DURATION_INCREMENT;
    
    int numNotes;
    dur playDuration;
    
    0 => int isOn;
    
    "SqrOscClusters" => string className;
    
    for (0 => int i; i < NUM_VOICES; i++)
    {
        sqr[i] => env[i] => env2 => pan[i] => dac;
        RAMPTIME::ms => env[i].duration;
    }
        
    fun void play()
    {
        while (true)
        {
            if (isOn % 2 == 0)
            { 
                break;
            }
            Math.random2f(-1.0, 1.0) => panning;
            
            for (0 => int i; i < NUM_VOICES; i++)
            {
                panning => pan[i].pan;
                Math.random2f(minGain, maxGain) => sqr[i].gain;
                Math.random2f(minFreq, maxFreq) => sqr[i].freq;
            }
            
            Math.random2(10, 40) => numNotes;           
            spork ~ playEnv2(numNotes);
            
            for (0 => int i; i < numNotes; i++)
            {
                for (0 => int j; j < NUM_VOICES; j++)
                {
                    1 => env[j].keyOn;
                }
                
                RAMPTIME::ms => now;
                ringtime::ms => now;
                
                for (0 => int j; j < NUM_VOICES; j++)
                {
                    1 => env[j].keyOff;
                } 
                RAMPTIME::ms => now;
            }
            Math.random2(200, 2000)::ms => now;        
        }
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
        GAIN_INCREMENT +=> minGain;
        GAIN_INCREMENT +=> maxGain;
        <<< "Increase", className, "gain to:", Std.ftoa(minGain, 2) + "-" + Std.ftoa(maxGain, 2) >>>;
    }
    
    fun void playEnv2(int i)
    {
        ((RAMPTIME * 2) + ringtime) * i::ms => playDuration;
        (playDuration / 4) => env2.duration;
        env2.keyOn();
        env2.duration() => now;
        playDuration - env2.duration() => env2.duration;
        env2.keyOff();
        env2.duration() => now;
    }
    
    fun void decreaseGain()
    {
        GAIN_INCREMENT -=> minGain;
        GAIN_INCREMENT -=> maxGain;
        if (minGain <= 0)
        {
            0 => minGain;
        }
        if (maxGain <= 0.02)
        {
            0.02 => maxGain;
        }
        <<< "Decrease", className, "gain to:", Std.ftoa(minGain, 2) + "-" + Std.ftoa(maxGain, 2) >>>;
    }
    
    fun void increaseRingtime()
    {
        DURATION_INCREMENT +=> ringtime;
        <<< "Increase", className, "duration to:", ringtime + 20, "ms" >>>; //20 == RAMPTIME 
    }
    
    fun void decreaseRingtime()
    {
        DURATION_INCREMENT -=> ringtime;
        if (ringtime <= 20)
        {
            20 => ringtime;
        }
        <<< "Decrease", className, "duration to:", ringtime + 20, "ms" >>>; //20 == RAMPTIME
    }
    
    fun void increasePitch()
    {
        PITCH_INCREMENT *=> minFreq;
        PITCH_INCREMENT *=> maxFreq;
        <<< "Increase", className, "pitch to:", Std.ftoa(minFreq, 0) + "-" + Std.ftoa(maxFreq, 0), "Hz" >>>;
    }
    
    fun void decreasePitch()
    {
        PITCH_INCREMENT /=> minFreq;
        PITCH_INCREMENT /=> maxFreq;
        if (minFreq <= 50)
        {
            50 => minFreq;
        }
        if (maxFreq <= 100)
        {
            100 => maxFreq;
        }
        <<< "Decrease", className, "pitch to:", Std.ftoa(minFreq, 0) + "-" + Std.ftoa(maxFreq, 0), "Hz" >>>;
    }
}