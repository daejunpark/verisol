DOTNET = dotnet
SOLUTION = Sources/SolToBoogie.sln

all: build

build:
	$(DOTNET) build $(SOLUTION)

clean:
	rm -rf "Source/SolidityAST/bin"
	rm -rf "Source/SolidityAST/obj"
	rm -rf "Source/SolidityCFG/bin"
	rm -rf "Source/SolidityCFG/obj"
	rm -rf "Source/BoogieAST/bin"
	rm -rf "Source/BoogieAST/obj"
	rm -rf "Source/SolToBoogie/bin"
	rm -rf "Source/SolToBoogie/obj"
