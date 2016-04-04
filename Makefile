PROG=create-bug.sh
PERM=750

EXE=bug.sh
SRC=gitignore.txt
TARGET=target.sh


all: clean setup create

create:
	@./$(PROG) $(SRC) $(TARGET) > $(EXE) && chmod $(PERM) $(EXE)

setup:
	@mkdir a b c; cd a; mkdir 1 2 3; cd 1; mkdir a b c; \
	cd a; mkdir 1 2 3; cd 1; mkdir a b c;

clean:
	@((rm *~ || /bin/true) && \
	(rm \#* || /bin/true) && \
	(rm $(EXE) || /bin/true) && \
	(rm -rf a b c || /bin/true)) 2>/dev/null

