# Makefile for C language exercise project

# Define the directory where the exercise files are stored
EXERCISE_DIR = ./exercises

# Define the test directory
TEST_DIR = ./test

# Ensure the test directory exists
$(shell mkdir -p $(TEST_DIR))

# Define the list of exercises
EXERCISES = $(wildcard $(EXERCISE_DIR)/*.c)

# Define the list of object files (.o)
OBJECTS = $(patsubst $(EXERCISE_DIR)/%.c, %.o, $(EXERCISES))

# Define the list of dependency files (.d)
DEPS = $(patsubst $(EXERCISE_DIR)/%.c, %.d, $(EXERCISES))

# Define the list of executables
EXECUTABLES = $(patsubst $(EXERCISE_DIR)/%.c, %, $(EXERCISES))

# Default target: build all executables
all: $(EXECUTABLES)

# Build rule for each executable
%: $(EXERCISE_DIR)/%.c
	gcc -o $@ $<

# Clean rule to remove all executables, object files, and dependency files
clean:
	rm -f $(EXECUTABLES) $(OBJECTS) $(EXERCISE_DIR)/*.d

# Generate test cases rule
generate-test-cases: $(EXECUTABLES)
	for exercise in $(EXERCISES); do \
    	exercise_name=$$(basename $$exercise .c); \
    	./$${exercise_name} > $(TEST_DIR)/$${exercise_name}.out; \
	done
	@$(MAKE) clean

# Test rule to compare output with expected results
test-output: $(EXECUTABLES)
	for exercise in $(EXERCISES); do \
    	exercise_name=$$(basename $$exercise .c); \
    	expected=$$(cat $(TEST_DIR)/$${exercise_name}.out); \
    	actual=$$(./$${exercise_name}); \
    	if [ "$$expected" = "$$actual" ]; then \
        	echo "Test for $$exercise_name passed."; \
    	else \
        	echo "Test for $$exercise_name failed."; \
        	echo "Expected:"; echo "$$expected"; \
        	echo "Actual:"; echo "$$actual"; \
    	fi; \
	done
	@$(MAKE) clean
