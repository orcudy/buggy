EXE=ant.sh
PERM=750

all: clean setup create

create:
	@./create-ant.sh gitignore.txt .gitignore > $(EXE) && chmod $(PERM) $(EXE)

setup:
	@mkdir a b c; cd a; mkdir 1 2 3; cd 1; mkdir a b c; \
	cd a; mkdir 1 2 3; cd 1; mkdir a b c;

clean:
	@((rm *~ || /bin/true) && \
	(rm \#* || /bin/true) && \
	(rm $(EXE) || /bin/true) && \
	(rm -rf a b c || /bin/true)) 2>/dev/null
