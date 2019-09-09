Program: partition.sh

Author: Matias Lin <<matiasenoclin@gmail.com>>

Date: 08/22/2019
********************************************************************************

Program Description:
--------------------
This program allows the user to partition a directory full of files into two
folders: train and validation. The user will be able to customize the percentage
of images in each folder.

Installation:
-------------
To clone this repository, use the following command:
      
        '$ git clone https://github.com/matiaslin/partition.git'

Usage:
------
1) To execute the program cd into the directory with the 'partition.sh' file and
enter either of the following commands:

  '$ ./get_data.sh' or '$ bash get_data.sh'

2) The user will be asked to enter '1' or '2' depending whether they want to 
partition the dataset into 'train and validation' or 'train, validation and
testing', respectively.

3) The program will then ask the user to input some information.
  * The PATH of the dataset. Note: When specifying absolute PATHS, the char '~'
  is not valid.
  * The percentage of the training data.
  * (If the user inputed '2') The percentage of the validation data.

4) The program will now ask for confirmation before intializing the partition.
After reviewing the information, if the user decides to continue then "y" should
be typed, otherwise, enter "n".

5) Once the program is finished, your dataset is going to be partitioned into 2
or 3 folders: train and validation (and testing, if the user inputed '2').

Copyrights and License:
-----------------------
This script is licensed under the [MIT License](LICENSE).
