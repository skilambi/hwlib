%% Author: Sai Kilambi
%% Date Created: Aug 12 2023
%% Description:
%
%  The main idea behind a gearbox fifo is that the input rate and the
%  output rate is the same. so for instance if you are converting from 64
%  bit at a certain rate to output 66 bit at the same clock rate. There
%  will be a point where the valid will go low for a cycle or two.
%  Depending on the relationship between the widths the average rates will
%  be equal.

clear;
clc;

%% Variables

in_width = 8;
out_width = 10;

N = 100;

in_data = randi(intmax("uint8"), N, 1);

wr_ptr = 0;
rd_ptr = 0;
bit_cnt = 0;


lcm_width = lcm(in_width, out_width);

% in_nsamp and out_nsamp are the number of samples where
% the number of bits match.
in_nsamp = lcm_width/in_width;
out_nsamp = lcm_width/out_width;

% Input buffer that stores upto two inputs
data_store = blanks(2*in_width);

%% Main loop
store_index = 1;

for i = 1:N
    ind1 = store_index*in_width + 1;
    ind2 = ind1 + in_width - 1;
    data_store(ind1:ind2) = dec2bin(in_data(i), in_width);
    
    % Count the total bits being stored currently
    bit_cnt = bit_cnt + in_width;

    % We dont really need wr_ptr but just generating it for RTL comparison
    wr_ptr = rem((wr_ptr + in_width), 2*in_width);
    
    % Generate rd_ptr
    if(bit_cnt >= out_width) % If there is enough number of bits then write
                             % it out else hold the index
        rd_ind2 = 2*in_width - rd_ptr;
        rd_ind1 = rd_ind2 - out_width + 1;

        bit_cnt = bit_cnt - out_width;
        rd_ptr = rem((rd_ptr + out_width), 2*in_width);
        
        if(rd_ind1 < 0)
            out_word = [data_store(2*in_width+rd_ind1: 2*in_width) data_store(1:rd_ind2)];
        else
            out_word = data_store(rd_ind1:rd_ind2);
        end
    end

    % Keep flipping the store index between 0 and 1
    if(store_index == 0)
        store_index = 1;
    else 
        store_index = 0;
    end
end