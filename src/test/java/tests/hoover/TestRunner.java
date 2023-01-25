package tests.hoover;

import com.intuit.karate.junit5.Karate;

public class TestRunner {
    @Karate.Test
    Karate testHoover() {
        return Karate.run("hoover").relativeTo(getClass());
    }
}
