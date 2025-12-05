package com.sathwik.converters.ExcelToSqlConverter.shedulers;

public class PulsingThread extends Thread {
    private volatile boolean running = true;

    @Override
    public void run() {
        try {
            while (running) {
                System.out.println("hello im pulsing");
                Thread.sleep(5000); // 5 seconds interval
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("Thread interrupted: " + e.getMessage());
        }
    }

    public void stopPulsing() {
        running = false;
        interrupt();
    }
}
