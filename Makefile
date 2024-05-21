﻿# Makefile for C language exercise project

# Define the directory where the exercise files are stored
EXERCISE_DIR = ./exercises

# Define the test directory
TEST_DIR = ./test

# Define the build directory
BUILD_DIR = ./build

# Ensure the test and build directories exist
$(shell mkdir -p $(TEST_DIR) $(BUILD_DIR))

# Define the list of exercises
EXERCISES = $(wildcard $(EXERCISE_DIR)/*.c)

# Define the list of executables
EXECUTABLES = $(patsubst $(EXERCISE_DIR)/%.c, $(BUILD_DIR)/%, $(EXERCISES))

# Default target: build all executables
all: $(EXECUTABLES) clean

# Build rule for each executable
$(BUILD_DIR)/%: $(EXERCISE_DIR)/%.c
	gcc -o $@ $<

# Clean rule to remove all executables and object files
clean:
	rm -f $(EXECUTABLES) $(BUILD_DIR)/*.o

# Generate test cases rule
generate-test-cases: $(EXECUTABLES)
	@for exe in $(EXECUTABLES); do \
    	./$$exe > $(TEST_DIR)/$$(basename $$exe).out; \
	done
	@$(MAKE) clean

# Test rule to compare output with expected results
test-output: $(EXECUTABLES)
	@for exe in $(EXECUTABLES); do \
    	exercise_name=$$(basename $$exe); \
    	expected=$$(cat $(TEST_DIR)/$${exercise_name}.out); \
    	actual=$$($$exe); \
    	if [ "$$expected" = "$$actual" ]; then \
        	echo "Test for $${exercise_name} passed."; \
    	else \
        	echo "Test for $${exercise_name} failed."; \
        	echo "Expected:"; echo "$$expected"; \
        	echo "Actual:"; echo "$$actual"; \
    	fi; \
	done
	@$(MAKE) clean

# New target to save test results and count pass rate
save-test-results: $(EXECUTABLES)
	@total=0; \
	passed=0; \
	> $(BUILD_DIR)/test_results.txt; \
	for exe in $(EXECUTABLES); do \
    	exercise_name=$$(basename $$exe); \
    	expected=$$(cat $(TEST_DIR)/$${exercise_name}.out); \
    	actual=$$($$exe); \
    	total=$$((total+1)); \
    	if [ "$$expected" = "$$actual" ]; then \
        	passed=$$((passed+1)); \
        	echo "Test for $${exercise_name} passed." >> $(BUILD_DIR)/test_results.txt; \
    	else \
        	echo "Test for $${exercise_name} failed." >> $(BUILD_DIR)/test_results.txt; \
        	echo "Expected:" >> $(BUILD_DIR)/test_results.txt; echo "$$expected" >> $(BUILD_DIR)/test_results.txt; \
        	echo "Actual:" >> $(BUILD_DIR)/test_results.txt; echo "$$actual" >> $(BUILD_DIR)/test_results.txt; \
    	fi; \
	done; \
	echo "Passed tests: $$passed/Total tests: $$total" >> $(BUILD_DIR)/test_results.txt
	@$(MAKE) clean
