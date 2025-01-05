#include <iostream>

#include "field.h"

#include <clang/AST/Decl.h>
#include <clang/AST/Expr.h>
#include <clang/ASTMatchers/ASTMatchers.h>
#include <clang/Rewrite/Core/Rewriter.h>
#include "clang/Basic/Diagnostic.h"

FieldTransformer::FieldTransformer(
    clang::ASTContext& context, clang::Rewriter& rewriter
)
    : Transformer(context, rewriter)
{}

void FieldTransformer::start()
{
    using namespace clang::ast_matchers;

    MatchFinder functionFinder;

    auto callExprMatcher = cxxConstructExpr(
                               isExpansionInMainFile(),
                               hasType(cxxRecordDecl(hasName("fvScalarField")))
    )
                               .bind("fvScalarField");
    functionFinder.addMatcher(callExprMatcher, this);

    functionFinder.matchAST(context);
}

void FieldTransformer::run(
    const clang::ast_matchers::MatchFinder::MatchResult& result
)
{
    using namespace clang;

    /*
     * CallExpr is the function call
     * FunctionDecl is fhe function definition
     */
    clang::DiagnosticsEngine& DE = this->context.getDiagnostics();
    //    clang::DiagnosticsEngine::Level level = DE.getDiagosticLevel(ID,
    //    SourceLocation());

    if (const CXXConstructExpr* callExpr =
            result.Nodes.getNodeAs<CXXConstructExpr>("fvScalarField"))
    {
        auto begin = callExpr->getBeginLoc();
        const unsigned ID = DE.getCustomDiagID(
            clang::DiagnosticsEngine::Warning, "I findz a badness"
        );
        DE.Report(begin, ID).AddString("foo");

        // auto Diag = diag(callExpr->getLocation(), "use NeoFOAM::VolumeField
        // instead of fvScalarField")
        // << callExpr
        // << FixItHint::CreateInsertion(callExpr->getLocation(),
        // "NeoFOAM::VolumeField");

        //    if (const FunctionDecl *function = callExpr->getDirectCallee())
        //    {
        //        if
        //        (result.SourceManager->isInSystemHeader(function->getSourceRange().getBegin()))
        //            return;

        //        auto functionName = function->getNameAsString();
        //        //rewriter.InsertTextAfter(callExpr->getBeginLoc(), "fn_");

        //        if (functions.count(functionName) == 0)
        //        {
        //            // rewrite definition as well
        //            //rewriter.InsertTextAfter(function->getLocation(),
        //            "fn_");
        //            //functions.insert(function->getNameAsString());
        //        }
        //    }
    }
}

void FieldTransformer::print(clang::raw_ostream& stream)
{
    // for (auto &fn : functions)
    //     stream << fn << "(..)\n";
}
