﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
namespace SolToBoogie
{
    using System.Collections.Generic;
    using System.Diagnostics;
    using SolidityAST;

    // desugar: add function names for constructors
    public class SolidityDesugaring : BasicASTVisitor
    {
        private TranslatorContext context;

        // current contract that the visitor is visiting
        private ContractDefinition currentContract;

        // current function that the visitor is visiting
        private FunctionDefinition currentFunction;

        // current statement that the visitor is visiting
        private Statement currentStatement;

        public SolidityDesugaring(TranslatorContext context)
        {
            this.context = context;
        }

        public override bool Visit(ContractDefinition node)
        {
            currentContract = node;
            return true;
        }

        public override void EndVisit(ContractDefinition node)
        {
            currentContract = null;
        }

        public override bool Visit(FunctionDefinition node)
        {
            Debug.Assert(currentContract != null);
            currentFunction = node;

            if (node.IsConstructorForContract(currentContract.Name) && string.IsNullOrEmpty(node.Name))
            {
                node.Name = currentContract.Name;
            }
            return false;
        }

        public override bool Visit(PlaceholderStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(IfStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(WhileStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(DoWhileStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(ForStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(Continue node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(Break node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(Return node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(Throw node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(EmitStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(VariableDeclarationStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(InlineAssembly node)
        {
            currentStatement = node;
            return true;
        }

        public override bool Visit(ExpressionStatement node)
        {
            currentStatement = node;
            return true;
        }

        public override void EndVisit(PlaceholderStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(IfStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(WhileStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(DoWhileStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(ForStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(Continue node)
        {
            currentStatement = null;
        }

        public override void EndVisit(Break node)
        {
            currentStatement = null;
        }

        public override void EndVisit(Return node)
        {
            currentStatement = null;
        }

        public override void EndVisit(Throw node)
        {
            currentStatement = null;
        }

        public override void EndVisit(EmitStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(VariableDeclarationStatement node)
        {
            currentStatement = null;
        }

        public override void EndVisit(InlineAssembly node)
        {
            currentStatement = null;
        }

        public override void EndVisit(ExpressionStatement node)
        {
            currentStatement = null;
        }


        private void InsertStatementBefore(FunctionDefinition function, Statement beforeThis, Statement stmt)
        {
            InsertStatementBeforeImpl(function.Body, beforeThis, stmt);
        }

        private void InsertStatementBeforeImpl(Block block, Statement beforeThis, Statement stmt)
        {
            for (int i = 0; i < block.Statements.Count; ++i)
            {
                Statement currentStmt = block.Statements[i];
                if (currentStmt == beforeThis)
                {
                    block.Statements.Insert(i, stmt);
                }
                else if (currentStmt is Block subBlock)
                {
                    InsertStatementBeforeImpl(subBlock, beforeThis, stmt);
                }
                else if (currentStmt is IfStatement ifStmt)
                {
                    if (ifStmt.TrueBody is Block)
                    {
                        InsertStatementBeforeImpl(ifStmt.TrueBody as Block, beforeThis, stmt);
                    }
                    else if (ifStmt.TrueBody == beforeThis)
                    {
                        ifStmt.TrueBody = CreateBlockFromTwoStatements(stmt, beforeThis);
                    }

                    if (ifStmt.FalseBody is Block)
                    {
                        InsertStatementBeforeImpl(ifStmt.FalseBody as Block, beforeThis, stmt);
                    }
                    else if (ifStmt.FalseBody == beforeThis)
                    {
                        ifStmt.FalseBody = CreateBlockFromTwoStatements(stmt, beforeThis);
                    }
                }
                else if (currentStmt is WhileStatement whileStmt)
                {
                    if (whileStmt.Body is Block)
                    {
                        InsertStatementBeforeImpl(whileStmt.Body as Block, beforeThis, stmt);
                    }
                    else if (whileStmt.Body == beforeThis)
                    {
                        whileStmt.Body = CreateBlockFromTwoStatements(stmt, beforeThis);
                    }
                }
                else if (currentStmt is ForStatement forStmt)
                {
                    if (forStmt.Body is Block)
                    {
                        InsertStatementBeforeImpl(forStmt.Body as Block, beforeThis, stmt);
                    }
                    else if (forStmt.Body == beforeThis)
                    {
                        forStmt.Body = CreateBlockFromTwoStatements(stmt, beforeThis);
                    }
                }
                else if (currentStmt is DoWhileStatement doStmt)
                {
                    if (doStmt.Body is Block)
                    {
                        InsertStatementBeforeImpl(doStmt.Body as Block, beforeThis, stmt);
                    }
                    else if (doStmt.Body == beforeThis)
                    {
                        doStmt.Body = CreateBlockFromTwoStatements(stmt, beforeThis);
                    }
                }
            }
        }

        private Block CreateBlockFromTwoStatements(Statement stmt1, Statement stmt2)
        {
            Block block = new Block();
            block.Scope = -1;
            block.Statements = new List<Statement>();
            block.Statements.Add(stmt1);
            block.Statements.Add(stmt2);
            return block;
        }
    }
}
