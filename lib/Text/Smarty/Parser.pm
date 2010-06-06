package  Text::Smarty::Parser;
use strict;
use warnings;
use IO::String;
use Params::Validate qw();
use Text::Smarty::Parser::Token::Variable;
use Text::Smarty::Parser::Token::Comment;
use Text::Smarty::Parser::Token::IF;
use Text::Smarty::Parser::Token::ELSEIF;
use Text::Smarty::Parser::Token::ELSE;
use Text::Smarty::Parser::Token::ENDIF;
use Text::Smarty::Parser::Token::String;
use Text::Smarty::Parser::Token::Function;
use Text::Smarty::Parser::Token::EndFunction;
use Text::Smarty::Parser::Token::Literal;
use Text::Smarty::Parser::Token::EndLiteral;

sub new {
    my $class = shift;

    my %options = Params::Validate::validate(@_, +{
        delim_start => { default => "{" },
        delim_end   => { default => "}" },
    });

    my $self = \%options;
    bless $self, $class;
}

sub parse {
    my ($self, $text) = @_;

    my $io_text = ref $text ? $text: IO::String->new($text);
    my @result;
    my $is_in_tag;
    my $is_in_litetag = 0;
    my $literal_token_buffer = "";
    my $is_in_literal = 0;
    my $token_buffer = "";
    while ( defined ( my $c = getc $io_text ) ) {
        if ( $is_in_literal ){
            $token_buffer .= $c;
            if ( $c eq $self->{delim_end} ) {
                if ( $literal_token_buffer eq '/literal' ) {
                    $token_buffer =~ s|@{[$self->{delim_start}]}/literal@{[ $self->{delim_end} ]}$||;
                    push @result, Text::Smarty::Parser::Token::String->new(string => $token_buffer); 
                    push @result, Text::Smarty::Parser::Token::EndLiteral->new(); 
                    $is_in_litetag--;
                    $is_in_literal--;
                    $token_buffer = "";
                    $literal_token_buffer = "";
                }
            }
            elsif ( $c eq $self->{delim_start} ) {
                $literal_token_buffer = "";
                $is_in_litetag++;
            }
            else {
                $literal_token_buffer .= $c;
            }
        }
        else{
            if( $is_in_tag ) {
                if ( $c eq $self->{delim_end} ) {
                    my $tag = $self->_handle_tag($token_buffer);
                    if ( $tag->isa("Text::Smarty::Parser::Token::Literal") ){
                        $is_in_literal++;
                    } elsif ( $tag->isa("Text::Smarty::Parser::Token::EndLiteral") ){
                        $is_in_literal--;
                    }
                    push @result, $tag;
                    $token_buffer = "";
                    $is_in_tag--;
                } else {
                    $token_buffer .= $c;
                }
            } else {
                if ( $c eq $self->{delim_start} ) {
                    push @result, Text::Smarty::Parser::Token::String->new(string => $token_buffer);
                    $token_buffer = "";
                    $is_in_tag++;
                } else {
                    $token_buffer .= $c;
                }
            }
        }
    }
    push @result, Text::Smarty::Parser::Token::String->new(string => $token_buffer);
    return \@result;
}

sub _handle_tag {
    my ($self, $tag) = @_;

    $tag =~ s/^\s*(.+?)\s*$/$1/;
    if ( $tag =~ /^\$(.+)$/ ) {
        return Text::Smarty::Parser::Token::Variable->new(name => $1);
    } else {
        if ( $tag =~ /^if (.+)$/ ) {
            return Text::Smarty::Parser::Token::IF->new(cond => [$1]);
        } elsif ( $tag =~ /^elseif (.+)$/ ) {
            return Text::Smarty::Parser::Token::ELSEIF->new(cond => [$1]);
        } elsif ( $tag eq 'else' ) {
            return Text::Smarty::Parser::Token::ELSE->new();
        } elsif ( $tag eq 'literal' ) {
            return Text::Smarty::Parser::Token::Literal->new();
        } elsif ( $tag eq '/literal' ) {
            return Text::Smarty::Parser::Token::EndLiteral->new();
        } elsif ( $tag eq '/if' ) {
            return Text::Smarty::Parser::Token::ENDIF->new();
        } elsif ( $tag =~ m/^\*\s*([^\*]+?)\s*\*$/ ) {
            return Text::Smarty::Parser::Token::Comment->new(comment => $1);
        } elsif ( $tag =~ m{^/(.+)} ) {
            return Text::Smarty::Parser::Token::EndFunction->new(name => $1);
        } elsif ( $tag =~ m{^([\S]+) (.+)$} ) {
            my $name = $1;
            my $arg_str = $2;
            my $args = {};
            for my $key_value ( split m/ /, $arg_str ) {
                my ($key, $value) = split m/=/, $key_value;
                $args->{$key} = $value;
            }
            return Text::Smarty::Parser::Token::Function->new(name => $name, args => $args);
        } elsif ($tag =~ m{^([a-zA-Z0-9_]+)$}) {
            return Text::Smarty::Parser::Token::Function->new(name => $1, args => {});
        } else {
            die "parse error";
        }
    }

    return $tag;
}


1;
__END__
=head2 NAME

Text::Smarty::Parser

=head2 SYNOPSIS

    my $parser = Text::Smarty::Parser->new(%option);
    my $result = $parser->parse("text");

