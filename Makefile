PROG=create-bug.sh
PERM=750

all: clean setup main gitignore license undo

main:
	@./$(PROG) -s programs/a.out -r -x > main.sh && chmod $(PERM) main.sh

gitignore:
	@./$(PROG) -s programs/gitignore.txt -r > gitignore.sh && chmod $(PERM) gitignore.sh

license:
	@./$(PROG) -s programs/gpl-v3.0 -r > license.sh && chmod $(PERM) license.sh

undo:
	@./$(PROG) -s programs/gpl-v3.0 -r -u > undo.sh && chmod $(PERM) undo.sh

setup:
	@mkdir a b c; cd a; mkdir 1 2 3; cd 1; mkdir a b c; \
	cd a; mkdir 1 2 3; cd 1; mkdir a b c;

clean:
	@((rm *~ || /bin/true) && \
	(rm \#* || /bin/true) && \
	(rm -rf a b c || /bin/true)
	(rm main.sh || /bin/true) && \
	(rm gitignore.sh || /bin/true) && \
	(rm license.sh || /bin/true) && \
	(rm undo.sh || /bin/true) && \) 2>/dev/null

