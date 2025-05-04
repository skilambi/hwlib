

`include "vunit_defines.svh"


module ring_buffer_tb;

    `TEST_SUITE begin 

        `TEST_SUITE_SETUP begin 
            // Initialize the testbench environment
            $display("Test suite setup for ring_buffer_tb");
        end

        `TEST_SUITE_CLEANUP begin 
            // Cleanup after all tests
            $display("Test suite cleanup for ring_buffer_tb");
        end

        `TEST_CASE("Test that a successful test case passes") begin
         $display("This test case is expected to pass");
         `CHECK_EQUAL(1, 1);
        end

        `TEST_CASE("Test that a failing test case actually fails") begin
            $display("This test case is expected to fail");
            `CHECK_EQUAL(0, 1, "You may also optionally add a diagnostic message to CHECK_EQUAL");
            // Note: A test case will also be marked as failing if the
            // simulator stops for other reasons before the end of the
            // TEST_SUITE block is reached. This means that you don't
            // need to use CHECK_EQUAL if the testbench you want to
            // convert to VUnit already contains code that for example
            // calls $stop if an error-condition is detected.
        end

    end // End of test suite

    `WATCHDOG(1000ns)
endmodule : ring_buffer_tb
// End of ring_buffer_tb.sv