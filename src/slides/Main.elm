module Main exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Html exposing (Html)
import Html.Attributes
import Markdown
import Slides exposing (slidesDefaultOptions)


title : List (Html msg)
title =
    [ md """

Coq's Prolog and applications to defining semi-automatic tactics
================================================================

Théo Zimmermann and Hugo Herbelin

TTT 2017

""" ]


introduction : List (Html msg)
introduction =
    [ md """

## Introduction

**Coq:** Both proof assistant and
programming language.

"""
    , md """

#### Applications

* **Software** certification.
* Teaching **programming** languages.
* Formalized **mathematics**.
* Teaching **logic** and what a proof is.

"""
    ]
        |> Html.div []
        |> \x -> [ x ]


tactics : List (Html msg)
tactics =
    [ md """

## Tactics

Building blocks for proofs.

From **primitive** (exact)...
to **semi-automatic** (rewrite)...
to **automatic** (tauto).

""" ]


rewrite : List (Html msg)
rewrite =
    [ md """

## Rewrite

Rewriting with **propositional equality** comes for free.

Rewriting with **custom equivalence** relations (or **order** relations) requires congruence lemmas...

and **automation** to use them.

""" ]


rewriteTechnical : List (Html msg)
rewriteTechnical =
    [ md """

## Rewrite's automation

Starts with:
`?newgoal → goal`

"""
    , md """

Decomposes the formulas step-by-step:
`(?1 → ?2) → (A → B)`
if `A → ?1` and `?2 → B`

"""
    , md """

Uses congruence lemmas:
`P x → P y` if `x < y`

"""
    , Html.footer [] [ md "**Cf.** Sozeau, M. (2010). [A new look at generalized rewriting in type theory.](https://jfr.unibo.it/article/view/1574) *J. Form. Reason.* 2(1), 41-62." ]
    ]


rewriteExample : List (Html msg)
rewriteExample =
    [ md """

## Example

Let's rewrite with `0 < 2` in `P 0 → ⊥`.

"""
    , md """

We get `(?1 → ?2) → (P 0 → ⊥)`
with `P 0 → ?1` and `?2 → ⊥`.

"""
    , md """
Then we get `P 0 → P ?y` with `0 < ?y`.

"""
    , md """
`0 < ?y` is resolved as `0 < 2`
and `?2 → ⊥` is resolved as `⊥ → ⊥`.

"""
    , md """
In the end we get `P 2 → ⊥`.

"""
    ]


transfer : List (Html msg)
transfer =
    [ md """

## Transfer

Transforms a goal on one type to an isomorphic (or merely related) type.

"""
    , md """

Also starts with:
`?newgoal → goal`

"""
    , md """

Uses congruence lemmas:
`(x + y) ≈ (x' +' y')`
if `x ≈ x'` and `y ≈ y'`

"""
    , Html.footer []
        [ md """

**Cf.** Zimmermann, T., & Herbelin, H. (2015). [Automatic and Transparent Transfer of Theorems along Isomorphisms in the Coq Proof Assistant.](http://arxiv.org/abs/1505.05028)
*CICM 2015 (work-in-progress track)*.

"""
        ]
    ]


comparison : List (Html msg)
comparison =
    [ md """

## Comparison

- Both rely on, Prolog-like, **automatic inference** using a set of rules.
- Rewrite uses *homogeneous* relations, transfer uses *heterogeneous* relations.
- Both are implemented upon Coq's **type class** mechanism.

""" ]


apply : List (Html msg)
apply =
    [ md """

## Apply

One of the most important tactics
(**modus ponens**).

Currently implemented in **OCaml**.

**Ad-hoc** support for **equivalence** lemmas and some other bits of intelligence.

How to **generalize** it to other forms of **trivial reasoning**?

""" ]


applyTechnical : List (Html msg)
applyTechnical =
    [ md """

## Apply's new automation


Starts with:
`theorem → goal`

"""
    , md """

Can leave some premises open:
`(A → B) → C`
if `B → C` and the user can prove `A`

"""
    , md """

Uses "views":
`(A ↔ B) → (A → B)`
`(x = y) → (y = x)`

"""
    ]


applyExamples : List (Html msg)
applyExamples =
    [ md """

## Examples of use

The theorem `(0 ≤ x ∧ x ≤ 0) ↔ x = 0`

applied to the goal:|gives the new goal:
-----------------|------
`x = 0` | `0 ≤ x ∧ x ≤ 0`
`0 = x` | `0 ≤ x ∧ x ≤ 0`
`0 ≤ x` | `x = 0`
`x ≤ 0` | `x = 0`

**Note:** 3 of these 4 examples were already handled by the OCaml implementation.

""" ]


reflect : List (Html msg)
reflect =
    [ md """

## Reflection lemmas

Some rules to use reflection lemmas:
`reflect P b → (P → b = true)`

So that one can apply `A → A ∨ B`
on the goal `(b1 || b2) = true`
and get the new goal `b1 = true`.

""" ]


applyComparison : List (Html msg)
applyComparison =
    [ md """

## Comparison

- Relies on the same kind of rule-based **automatic inference**.
- Only requires *homogeneous* relations as for rewrite.
- **Theorem** and **goal** are both known.

""" ]


typeclasses : List (Html msg)
typeclasses =
    [ md """

## Implementation detail

We don't strictly need the
**type class** mechanism.

But only the underlying
**proof-search** mechanism.

This mechanism is directly accessible
and can be instrumented.

"""
    , Html.footer
        [ [ marginTop (px 80) ] |> asPairs |> Html.Attributes.style ]
        [ md "**Cf.** the abstract for this talk." ]
    ]
        |> Html.div []
        |> \x -> [ x ]


conclusion : List (Html msg)
conclusion =
    [ md """


## Conclusion

- **Benefits**: *Simpler*, easily *extensible* implementation.

- **Drawbacks**: *Performance*.
How to have good *error* messages?

- **Future work**: Further develop this *proof-of-concept* and integrate in Coq.
Merge with the *transfer* mechanism.

""" ]


main : Program Never Slides.Model Slides.Msg
main =
    [ title
    , introduction
    , tactics
    , rewrite
    , rewriteTechnical
    , rewriteExample
    , transfer
    , comparison
    , apply
    , applyTechnical
    , applyExamples
    , reflect
    , applyComparison
    , typeclasses
    , conclusion
    ]
        |> List.map Slides.htmlFragments
        |> Slides.app { slidesDefaultOptions | style = myStyle }


md : String -> Html msg
md =
    Markdown.toHtmlWith
        { githubFlavored = Just { tables = True, breaks = True }
        , defaultHighlighting = Nothing
        , sanitize = False
        , smartypants = True
        }
        []


myStyle : List Css.Snippet
myStyle =
    [ body
        [ padding zero
        , margin zero
        , height (pct 100)
        , backgroundColor (hex "effafa")
        , color (rgb 0 0 0)
        , fontFamilies [ qt "Open Sans", sansSerif.value ]
        , fontSize (px 38)
        , fontWeight (int 400)
        , textAlign center
        , lineHeight (pct 150)
        ]
    , h1
        [ fontWeight (int 600)
        , marginTop (px 150)
        ]
    , h2
        [ fontWeight (int 600)
        ]
    , h4
        [ marginBottom (px -30)
        ]
    , section
        [ height (px 700)
        , property "background-position" "center"
        , property "background-size" "cover"
        , displayFlex
        , property "justify-content" "center"
        , alignItems left
        ]
    , footer
        [ fontSize (px 22)
        , lineHeight (pct 130)
        ]
    , p
        [ margin (px 15)
        ]
    , li
        [ textAlign left
        ]
    , (.) "slide-content"
        [ margin2 zero (px 90)
        ]
    , code
        [ textAlign left
        , fontFamilies [ qt "Nova Mono", monospace.value ]
        , padding (px 12)
        , color (rgb 0 100 255)
        ]
    , a
        [ color (rgb 0 0 0)
        ]
    , table
        [ margin2 zero auto
        ]
    , th
        [ padding2 zero (px 25)
        , fontWeight (int 400)
          -- no bold by default in table header
        ]
    ]
