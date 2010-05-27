use strict;
use warnings;
use utf8;
use Encode;
use Test::Base;
use Test::Differences;
use Text::Smarty::Parser;
use Text::Smarty::Parser::Token::Variable;
use Text::Smarty::Parser::Token::IF;
use Text::Smarty::Parser::Token::Function;
use Text::Smarty::Parser::Token::EndFunction;

plan tests => 1*blocks;

run {
    my $block = shift;

    my $parser = Text::Smarty::Parser->new;
    my $expected = $parser->parse($block->input);
    eq_or_diff($expected, $block->expected, Encode::encode_utf8($block->name));

};

__END__
=== 変数展開
--- input
あいうえお
{$var}
かきくけこ

--- expected eval
[
    Text::Smarty::Parser::Token::String->new(string => "あいうえお\n"),
    Text::Smarty::Parser::Token::Variable->new(name => "var"),
    Text::Smarty::Parser::Token::String->new(string => "\nかきくけこ\n"),
]

=== IF文
--- input
あいうえお
{if $var}
かきくけこ
{elseif $var}
ほげ
{else}
さしすせそ
{/if}
たちつてと

--- expected eval
[
    Text::Smarty::Parser::Token::String->new(string => "あいうえお\n"),
    Text::Smarty::Parser::Token::IF->new(cond => ['$var']),
    Text::Smarty::Parser::Token::String->new(string => "\nかきくけこ\n"),
    Text::Smarty::Parser::Token::ELSEIF->new(cond => ['$var']),
    Text::Smarty::Parser::Token::String->new(string => "\nほげ\n"),
    Text::Smarty::Parser::Token::ELSE->new(),
    Text::Smarty::Parser::Token::String->new(string => "\nさしすせそ\n"),
    Text::Smarty::Parser::Token::ENDIF->new(),
    Text::Smarty::Parser::Token::String->new(string => "\nたちつてと\n"),
]

=== Comment
--- input
てすてす
{* これはコメントです *}
てすてす

--- expected eval
[
    Text::Smarty::Parser::Token::String->new(string => "てすてす\n"),
    Text::Smarty::Parser::Token::Comment->new(comment => "これはコメントです"),
    Text::Smarty::Parser::Token::String->new(string => "\nてすてす\n"),
]

=== section
--- input
あいうえお
{section name=rows loop=$data}
かきくけこ
{/section}

--- expected eval
[
    Text::Smarty::Parser::Token::String->new(string => "あいうえお\n"),
    Text::Smarty::Parser::Token::Function->new(name => "section", args => { name => "rows", loop => '$data' }),
    Text::Smarty::Parser::Token::String->new(string => "\nかきくけこ\n"),
    Text::Smarty::Parser::Token::EndFunction->new(name => "section"),
    Text::Smarty::Parser::Token::String->new(string => "\n"),
];

