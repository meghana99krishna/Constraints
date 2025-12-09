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
      
