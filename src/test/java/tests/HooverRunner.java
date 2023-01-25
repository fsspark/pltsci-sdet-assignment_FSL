package tests;

import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;


public class HooverRunner {
    @Test
    void hooverTest() {
        Runner.path("classpath:tests");
    }
}
