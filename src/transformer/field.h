#pragma once

#include "transformer.h"

#include <set>
#include <string>

namespace clang
{
class ASTContext;
// class raw_ostream;
class Rewriter;
} // namespace clang

class FieldTransformer : public Transformer
{
private:

    std::set<std::string> functions;

public:

    explicit FieldTransformer(
        clang::ASTContext& context, clang::Rewriter& rewriter
    );

    virtual void start() override;
    virtual void run(const clang::ast_matchers::MatchFinder::MatchResult& result
    );
    virtual void print(clang::raw_ostream& stream) override;
};
