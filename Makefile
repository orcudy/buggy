PROG=create-bug.sh
PERM=750
all: setup main license undo-main undo-license
	@echo "Moving scripts into sanbox"
	@mv main.sh sandbox
	@mv license.sh sandbox
	@mv undo-license.sh sandbox
	@mv undo-main.sh sandbox

main:
	@echo "Creating main.sh"
	@./$(PROG) -s programs/a.out -r -x > main.sh
	@chmod $(PERM) main.sh

license:
	@echo "Creating license.sh"
	@./$(PROG) -s programs/gpl-v3.0 -r -c > license.sh
	@chmod $(PERM) license.sh

undo-license:
	@echo "Creating undo-license.sh"
	@./$(PROG) -s programs/gpl-v3.0 -r -u > undo-license.sh
	@chmod $(PERM) undo-license.sh

undo-main:
	@echo "Creating undo-main.sh"
	@gcc programs/main.c -o programs/a.out
	@cd programs; ./a.out
	@./$(PROG) -s programs/message.txt -r -u > undo-main.sh
	@chmod $(PERM) undo-main.sh

setup:
	@echo "Creating sandbox"
	@mkdir sandbox; cd sandbox; mkdir a b c; cd a; mkdir 1 2 3; cd 1; mkdir a b c; \
	cd a; mkdir 1 2 3; cd 1; mkdir a b c;

clean:
	@echo "Cleaning up"
	@( \
	(rm *~ || /bin/true) && \
	(rm -rf sandbox || /bin/true) && \
	(rm main.sh || /bin/true) && \
	(rm license.sh || /bin/true) && \
	(rm undo.sh || /bin/true) && \
	(rm -rf $(SCRIPTDIR) || /bin/true) \
	) 2>/dev/null

