# Syllables Project Documentation

## Project Description

This project, developed as part of the Rule-Based Programming course, represents a Prolog system capable of managing syllable separation rules for Romanian words.

## Requirements

Implement a Prolog system capable of:

1. Reading a word and displaying its syllable-separated version.
   - Example: `cuvânt` -> `cu-vânt`

2. Checking the correctness of a word's syllable separation.
   - Example 1: `cre-ion` -> `correct`
   - Example 2: `crei-on` -> `incorrect`

3. Given a set of syllables, generate all possible combinations of words that respect the Romanian language's syllable separation rules.

## Steps to execute the Prolog code:

1. Install Prolog 8.5.20-1 on your system.

2. Open the SWI-Prolog console, where you can perform one of the following functionalities:

   - 2.1 Syllable Separation of a Word:
   
     ```prolog
     ?- syllable_separation("cuvant", Syllables).  % -> cu-vant
     ?- syllable_separation("minunat", Syllables).  # -> mi-nu-nat
     ?- syllable_separation("facultate", Syllables).  # -> fa-cul-ta-te
     ```
     "cuvant" can be replaced with the desired word for separation.
     
   - 2.2 Checking Correctness of a Syllable Separation:
   
     ```prolog
     ?- verify_correct_separation("syllable1-syllable2-syllable3-...-syllableN", Word). # general example
     ?- verify_correct_separation("mi-nu-nat", Word). # correct syllable separation
     ?- verify_correct_separation("fa-cul-ta-te", Word). # correct syllable separation
     ?- verify_correct_separation("fa-culta-te", Word). # incorrect syllable separation
     ```
     
     "syllable1-syllable2-syllable3-...-syllableN" represents all syllables separated by hyphens, forming the word for which the check is desired.
     
   - 2.3 Generating All Valid Combinations of Syllable Separation:
   
     ```prolog
     ?- generate_syllable_combinations("syllable1-syllable2-syllable3-...-syllableN", Words). # general example
     ?- generate_syllable_combinations("u-re-che", Words). # ureche, uchere
     ?- generate_syllable_combinations("ca-mi-la", Words). # camila, calami, micala, milaca, lacami, lamica
     ```
     
     "syllable1-syllable2-syllable3-...-syllableN" represents all syllables separated by hyphens, forming the set of syllables for which the generation is desired.

## Steps to open the graphical interface:
  1. Install Python 3.9.13 on your system.
  2. Run the main.py file from the command line using the following command:
    - ```
     python .\main.py
    ```

## Rationale for Implementation Choices:
  1. To have a well-structured program, separate rules were implemented in Prolog for each requirement and each grammatical rule.
  2. The set of syllables is constructed using lists, which are easy to work with.
  3. It is worth mentioning that the "permutation" method was used to create all possible permutations of the given syllables.
  4. For ease of implementing the graphical interface, the tkinter library from Python was chosen.
  5. To integrate Prolog into the tkinter application, the pyswip library from the Prolog module was used. This library was chosen because it is well-documented, and more information can be found [here](https://github.com/yuce/pyswip).

## Contributions

The following individuals contributed to this project:
1. Macsim Oana
2. Dobre Roxana
3. Dogaru Simona
4. Ghioc Otilia
5. Galatanu Bogdan


The entire team acknowledges special contributions from Otilia Ghioc and Bogdan Galatanu, who demonstrated exceptional involvement in creating this project.

## License

This project is licensed under the [MIT License](LICENSE).
