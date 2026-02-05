class C;
  rand int flat[27];   // stores 27 unique elements
       int a[3][3][3];

  // Ensure all 27 elements are unique
  constraint c_unique {
    unique { flat };
  }

  // Move flat[] values into a 3D array
  function void post_randomize();
    int idx = 0;
    foreach(a[i,j,k])
      a[i][j][k] = flat[idx++];

    // Display the 3D array
    $display("----- 3D Array Contents -----");
    foreach (a[i,j,k]) begin
      $display("a[%0d][%0d][%0d] = %0d", i, j, k, a[i][j][k]);
    end
  endfunction
endclass
module tb;
  initial begin
    C c = new();
    if (!c.randomize())
      $display("Randomization failed!");
  end
endmodule
class C;
  rand int a[3][3][3];

  // Constraint: All elements in 3D matrix must be unique
  constraint uniq_3d {
    foreach (a[i,j,k])
      foreach (a[x,y,z])
        if (!((i==x) && (j==y) && (k==z)))
          a[i][j][k] != a[x][y][z];
  }

  // Display function
  function void display();
    int i, j, k;
    for (i = 0; i < 3; i++) begin
      $display("\nLayer i = %0d", i);
      for (j = 0; j < 3; j++) begin
        for (k = 0; k < 3; k++) begin
          $display("a[%0d][%0d][%0d] = %0d", i, j, k, a[i][j][k]);
        end
      end
    end
  endfunction
endclass
module tb;

  initial begin
    C c1 = new();

    if (!c1.randomize()) begin
      $display("Randomization failed");
      $finish;
    end

    // Display the 3D array
    c1.display();
    $finish;
  end

endmodule
//////////////////////////////////////////////////////////
module reverse_queue_tb;

  class Reverse;
    // Original queue
    int q[5] = '{10, 20, 30, 40, 50};

    // Reversed output
    rand int rev_q[5];

    // Constraint to reverse the queue
    constraint c_reverse {
      foreach (rev_q[i]) {
        rev_q[i] == q[$size(q)-1 - i];
      }
    }

  endclass


  initial begin
    Reverse r = new();

    if (!r.randomize())
      $fatal("Randomization failed!");

    $display("Original Queue = %p", r.q);
    $display("Reversed Queue = %p", r.rev_q);
  end

endmodule
///////////////////////////////////
  class pattern_1122334455;
  rand int a[10];

  // Constraint to generate 1122334455
  constraint pattern_c {
    foreach (a[i]) begin
      if (i % 2 == 0)
        a[i] == (i/2) + 1;
      else
        a[i] == ((i-1)/2) + 1;
    end
  }

  // Display method
  function void display();
    $display("Generated pattern:");
    foreach (a[i]) $write("%0d ", a[i]);
    $write("\n");
  endfunction
endclass


module tb;
  initial begin
    pattern_1122334455 p = new();

    if (p.randomize()) begin
      p.display();
    end
    else begin
      $display("Randomization failed");
    end

    $finish;
  end
endmodule
///////////////////////////////////////
      class SORTER_or_ascending;
  rand int da[];   // dynamic array

  // Fix the size (example: 10 elements)
  constraint size_c {
    da.size() == 10;
  }

  // Constraint to sort array in ascending order
  constraint sort_c {
    foreach (da[i])
      if (i > 0)
        da[i] >= da[i-1];   // ascending ordering rule
  }

endclass
////////////////////////////////////////
  class PatternB;
  rand bit [2:0] data[9:0];

  constraint c_pairs {
    // ensure each pair has the same value and pairs increase from 0..4
    foreach (data[i]) begin
      if (i % 2 == 1) begin
        // odd index equals previous (make pair)
        data[i] == data[i-1];
      end
      // for the first element of each pair, force it to the pair index
      if (i % 2 == 0) begin
        data[i] == (i/2);
      end
    end
  }
endclass

module tb_b;
  initial begin
    PatternB p = new();
    if (!p.randomize()) $fatal("Randomize failed");
    $display("PatternB = %p", p.data);
    // prints: PatternB = '{0,0,1,1,2,2,3,3,4,4}
  end
endmodule
      ///////////////////////////////////////
class pattern_gen;
  rand int a[18];

  // Easy constraint
  constraint pattern_c {
    foreach (a[i]) 
      a[i] == i/3;
  }

  function void display();
    foreach (a[i]) $write("%0d ", a[i]);
    $write("\n");
  endfunction
endclass


module tb;
  initial begin
    pattern_gen p = new();

    p.randomize();
    p.display();

    $finish;
  end
endmodule

      //////////////////////////////////////////
      Auto Prediction

“Auto prediction automatically updates the register mirror during frontdoor accesses without observing the bus.”

Explicit Prediction

“Explicit prediction manually updates the register mirror using predict() after a transaction.”

Passive Prediction

“Passive prediction updates the register mirror by observing actual bus transactions via a monitor and reg predictor.”/////////

      
module tb;
  int q[$] = '{1, 2, 3, 2, 4, 1};
  bit seen[int];
  int first_dup;
  bit found = 0;

  initial begin
    foreach (q[i]) begin
      if (seen.exists(q[i])) begin
        first_dup = q[i];
        found = 1;
        break;
      end
      else
        seen[q[i]] = 1;
    end

    if (found)
      $display("First duplicate = %0d", first_dup);
  end
endmodule
/////////////////////////////
      module tb_dup_simple;

  int q[$] = '{1, 2, 3, 2, 4, 1, 5};
  int dup[$];

  initial begin
    for (int i = 0; i < q.size(); i++) begin
      for (int j = i+1; j < q.size(); j++) begin
        if (q[i] == q[j] && !(q[i] inside {dup}))
          dup.push_back(q[i]);
      end
    end

    $display("Input      = %p", q);
    $display("Duplicates = %p", dup);
  end

endmodule
////////////////////////////////////////////
      
`timescale 1ns/1ps

// -------------------------------------------------
// Traffic type enum
// -------------------------------------------------
typedef enum int {UNICAST, MULTICAST, BROADCAST} traffic_t;

// -------------------------------------------------
// Packet class
// -------------------------------------------------
class pkt;

  rand traffic_t  t;
  rand bit [31:0] addr;

  // Traffic type distribution
  constraint c_type_dist {
    t dist {
      UNICAST   := 60,
      MULTICAST := 30,
      BROADCAST := 10
    };
  }

  // Address mapping using implication
  constraint c_addr_map {
    (t == UNICAST)   -> addr inside {[32'h0000_0000 : 32'h0FFF_FFFF]};
    (t == MULTICAST) -> addr inside {[32'h1000_0000 : 32'h1FFF_FFFF]};
    (t == BROADCAST) -> addr inside {[32'h2000_0000 : 32'h2FFF_FFFF]};
  }

endclass

// -------------------------------------------------
// Testbench
// -------------------------------------------------
module tb;

  pkt p;

  initial begin
    p = new();

    repeat (10) begin
      assert(p.randomize());

      $display("TYPE=%0s  ADDR=%h",
               p.t.name(), p.addr);
    end

    $finish;
  end

endmodule
///////////////////////////////////////////////
      
