package com.sathwik.converters.ExcelToSqlConverter.shedulers;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class pulseScheduler {

    @Scheduled(fixedRate = 5000 * 60)
    public void pulseMaker(){
        System.out.println("Pulsing");
    }
}
