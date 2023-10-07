breed [leoes leao]
breed [hienas hiena]

turtles-own [energia ableToBreed]

hienas-own [nivelAgrupamento]
leoes-own [timerDescanso]


to Setup
  clear-all
  SetupPatches
  SetupAgentes
  reset-ticks
end


to Go
  ask turtles with [ energia <= 0 ]
  [
    die
  ]

  if count turtles = 0
  [
    stop
  ]

  ifelse hienasMelhoradas?
  [
    acaoHienaMelhorado
  ]
  [
    acaoHiena
  ]

   ifelse leoesMelhorados?
  [
    acaoLeaoMelhorado
  ]
  [
    acaoLeao
  ]

  if reproduzir?
  [
    reproduzir
  ]

  tick
end


;;;; PATCHES

to SetupPatches
  initPatches brown
  initPatches red
  SetupBluePatches
end

to initPatches [cor]
  ask patches
  [
    let x random 101

    if x < AlimentoPeqPorte
    [
      set pcolor cor
    ]
  ]
end

to SetupBluePatches
  repeat nCelulasAzuis
  [
    let x random-xcor
    let y random-ycor

    ask patch x y
    [
      set pcolor blue
    ]
  ]
end

;;;; AGENTES

to SetupAgentes
  createLeoes
  createHienas
  ask turtles
  [
    let x random-xcor
    let y random-ycor
    let headingDirection (random 360)

    set size 1.5
    setxy x y
    set heading headingDirection
    set ableTobreed 1
  ]
end

to SetupTurtles [turt forma cor en]
  ask turt
  [
    set shape forma
    set color cor
    set energia en
  ]
end

;;;;;;;; LEOES

to CreateLeoes
  create-leoes nLeoes
  SetupTurtles leoes "person" yellow energiaLeao
end

;;;;;;;; HIENAS

to CreateHienas
  create-hienas nHienas
  SetupTurtles hienas "cow" pink energiaHiena
end


;;;; AÇÕES

to comer
  let isCurrentPatchBrown [pcolor] of patch-here = brown
  let isCurrentPatchRed [pcolor] of patch-here = red

  ifelse isCurrentPatchBrown
  [
    set pcolor black
    set energia (energia + energiaObtida)

    ask one-of patches with [pcolor = black]
    [
      set pcolor brown
    ]

  ]
  [;else
    if isCurrentPatchRed
    [
      set pcolor brown
      set energia (energia + energiaObtida)
    ]
  ]
end

to acaoHiena
  ask hienas [
    let frontPatch patch-ahead 1
    let leftPatch patch-left-and-ahead 90 1
    let rightPatch patch-right-and-ahead 90 1
    let currentPatch patch-here

    let hienasOnLeft count hienas-on leftPatch
    let hienasOnRight count hienas-on rightPatch
    let hienasInFront count hienas-on frontPatch

    let hienasOnCurrent (count hienas-on currentPatch - 1)
    set nivelAgrupamento hienasOnLeft + hienasOnRight + hienasInFront + hienasOnCurrent
    let nleoesOnLeft count leoes-on leftPatch
    let nleoesOnRight count leoes-on rightPatch
    let nleoesInFront count leoes-on frontPatch
    let nleoesInCurrent count leoes-on currentPatch
    let nleoesInVizinhancaP nleoesOnLeft + nleoesOnRight + nleoesInFront + nleoesInCurrent
    let foodOnCurrentPatch pcolor = brown or pcolor = red

    let indHienasOnLeft hienas-on leftPatch
    let indHienasOnRight hienas-on rightPatch
    let indHienasInFront hienas-on frontPatch
    let indHienasInCurrent hienas-on currentPatch

    if [pcolor] of leftPatch = blue [
      set nleoesOnLeft 0
    ]
    if [pcolor] of rightPatch = blue [
      set nleoesOnRight 0
    ]
    if [pcolor] of frontPatch = blue [
      set nleoesInFront 0
    ]
    if [pcolor] of currentPatch = blue [
      set nleoesInCurrent 0
    ]

    ifelse nivelAgrupamento > 0 ;cor default pink
    [
      set color blue ;mudada
    ]
    [
      set color pink ;default
    ]

    ifelse foodOnCurrentPatch
    [
      comer
    ]
    [
      ifelse nivelAgrupamento > 1
      [
        ifelse nleoesInVizinhancaP = 1
        [
          ifelse  nleoesOnLeft = 1
          [
            let targetLeao one-of leoes-on leftPatch

             let energyToDeduct  ([energia] of targetLeao) * (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

              ask indHienasOnLeft [
                set energia energia - energyToDeduct
              ]
              ask indHienasOnRight [
                set energia energia - energyToDeduct
              ]
              ask indHienasInFront [
                set energia energia - energyToDeduct
              ]
              ask indHienasInCurrent [
                set energia energia - energyToDeduct
              ]
            ask targetLeao
            [
              die
            ]
            ask leftPatch
            [
              set pcolor red
            ]
          ]
          [
            ifelse nleoesOnRight = 1
            [
              let targetLeao one-of leoes-on rightPatch
              let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

              ask indHienasOnLeft [
                set energia energia - energyToDeduct
              ]
              ask indHienasOnRight [
                set energia energia - energyToDeduct
              ]
              ask indHienasInFront [
                set energia energia - energyToDeduct
              ]
              ask indHienasInCurrent [
                set energia energia - energyToDeduct
              ]
              ask targetLeao
              [
                die
              ]
              ask rightPatch
              [
                set pcolor red
              ]
            ]
            [
              ifelse nleoesInFront = 1
              [
                let targetLeao one-of leoes-on frontPatch

                let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

                ask indHienasOnLeft [
                  set energia energia - energyToDeduct
                ]
                ask indHienasOnRight [
                  set energia energia - energyToDeduct
                ]
                ask indHienasInFront [
                  set energia energia - energyToDeduct
                ]
                ask indHienasInCurrent [
                  set energia energia - energyToDeduct
                ]
                ask targetLeao
                [
                  die
                ]
                ask frontPatch
                [
                  set pcolor red
                ]
              ]
              [
                if nLeoesInCurrent = 1
                [
                  let targetLeao one-of leoes-on currentPatch
                  let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

                  ask indHienasOnLeft [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasOnRight [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasInFront [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasInCurrent [
                    set energia energia - energyToDeduct
                  ]

                  ask targetLeao
                  [
                    die
                  ]
                  ask rightPatch
                  [
                    set pcolor red
                  ]
                ]
              ]
            ]
          ]
        ]
        [
          set energia energia - 1
          if nleoesInVizinhancaP = 0
          [
            andarNormal
            let currentHeading heading

            ask indHienasOnLeft [
              set heading currentHeading
            ]
            ask indHienasOnRight [
              set heading currentHeading
            ]
            ask indHienasInFront [
              set heading currentHeading
            ]
            ask indHienasInCurrent [
              set heading currentHeading
            ]
          ]
        ]
      ]
      [
        set energia energia - 1
        andarNormal
      ]
    ]
    ;nao ver celulas azuis



  ]
end


to acaoLeao
  ask leoes
  [
    let frontPatch patch-ahead 1
    let leftPatch patch-left-and-ahead 90 1
    let rightPatch patch-right-and-ahead 90 1
    let currentPatch patch-here
    let foodOnfrontPatch [pcolor] of frontPatch = red or [pcolor] of frontPatch = brown
    let foodOnLeftPatch [pcolor] of leftPatch = red or [pcolor] of leftPatch = brown
    let foodOnRightPatch [pcolor] of rightPatch = red or [pcolor] of rightPatch = brown
    let foodOnCurrentPatch [pcolor] of currentPatch = red or [pcolor] of currentPatch = brown

    let inBluePatch [pcolor] of currentPatch = blue
    let nHienasLeftPatch count hienas-on leftPatch
    let nHienasRightPatch count hienas-on rightPatch
    let nHienasFrontPatch count hienas-on frontPatch
    let killLeftPatch nHienasLeftPatch = 1 and nHienasRightPatch = 0 and nHienasFrontPatch = 0
    let killRightPatch nHienasRightPatch = 1 and nHienasLeftPatch = 0 and nHienasFrontPatch = 0
    let killfrontPatch nHienasFrontPatch = 1 and nHienasRightPatch = 0 and nHienasLeftPatch = 0

    ifelse inBluePatch
    [
      if (ticks - timerDescanso) > descansoLeao
      [
        fd 1
      ]
    ]
    [
      set timerDescanso ticks     ;atualiza sempre
      ifelse energia < fomeLeao
      [
        ifelse foodOnCurrentPatch
        [
          comer
        ]
        [;else
          set energia energia - 1
          ifelse foodOnFrontPatch
          [
            fd 1
          ]
          [;else
            ifelse foodOnLeftPatch
            [
              left 90
            ]
            [;else
              ifelse foodOnRightPatch
              [
                right 90
              ]
              [;else
                ifelse killLeftPatch
                [
                  let targetHiena one-of hienas-on leftPatch
                  set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                  ask leftPatch [set pcolor brown]
                  ask targetHiena [die]
                ]
                [;else
                  ifelse killRightPatch
                  [
                    let targetHiena one-of hienas-on rightPatch
                    set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                    ask rightPatch [set pcolor brown]
                    ask targetHiena [die]
                  ]
                  [;else
                    ifelse killFrontPatch
                    [
                      let targetHiena one-of hienas-on frontPatch
                      set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                      ask frontPatch [set pcolor brown]
                      ask targetHiena [die]
                    ]
                    [;else
                      andarNormal
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
      [;else energia > fomeLeao (movimento especial)
        ifelse nHienasLeftPatch >= 1 and nHienasRightPatch >= 1
        and nHienasFrontPatch >= 1
        [
          set energia energia - 5
          back 2
        ]
        [;else
          ifelse nHienasRightPatch >= 1 and nHienasFrontPatch >= 1
          [
            set energia energia - 5
            back 1
            left 90
            fd 1
          ]
          [;else
            ifelse nHienasLeftPatch >= 1 and nHienasFrontPatch >= 1
            [
              set energia energia - 5
              back 1
              right 90
              fd 1
            ]
            [;else
              ifelse nHienasRightPatch >= 2 or (nHienasLeftPatch >= 1
                and nHienasRightPatch >= 1)
              [
                set energia energia - 3
                back 1
              ]
              [;else
                ifelse nHienasRightPatch >= 2
                [
                  set energia energia - 2
                  left 90
                  fd 1
                ]
                [;else
                  ifelse nHienasLeftPatch >= 2
                  [
                    set energia energia - 2
                    right 90
                    fd 1
                  ]
                  [;else
                    ifelse foodOnCurrentPatch
                    [
                      comer
                    ]
                    [;else
                      ifelse killLeftPatch
                      [
                        let targetHiena one-of hienas-on leftPatch
                        set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                        ask leftPatch [set pcolor brown]
                        ask targetHiena [die]
                      ]
                      [;else
                        ifelse killRightPatch
                        [
                          let targetHiena one-of hienas-on rightPatch
                          set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                          ask rightPatch [set pcolor brown]
                          ask targetHiena [die]
                        ]
                        [;else
                          ifelse killFrontPatch
                          [
                            let targetHiena one-of hienas-on frontPatch
                            set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                            ask frontPatch [set pcolor brown]
                            ask targetHiena [die]
                          ]
                          [;else
                            set energia energia - 1
                            andarNormal
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end

to andarNormal
  let x random 101

  ifelse x < 33
  [
    left 90
  ]
  [;else
    ifelse x < 66
    [
      right 90
    ]
    [;else
      fd 1
    ]
  ]
end


;%%%%%%%%%%%%%%MELHORADO%%%%%%%%%%%%%%%%%%

to acaoLeaoMelhorado
  ask leoes
  [
    let frontPatch patch-ahead 1
    let leftPatch patch-left-and-ahead 90 1
    let rightPatch patch-right-and-ahead 90 1
    let currentPatch patch-here
    let foodOnfrontPatch [pcolor] of frontPatch = red or [pcolor] of frontPatch = brown
    let foodOnLeftPatch [pcolor] of leftPatch = red or [pcolor] of leftPatch = brown
    let foodOnRightPatch [pcolor] of rightPatch = red or [pcolor] of rightPatch = brown
    let foodOnCurrentPatch [pcolor] of currentPatch = red or [pcolor] of currentPatch = brown

    let inBluePatch [pcolor] of currentPatch = blue
    let nHienasLeftPatch count hienas-on leftPatch
    let nHienasRightPatch count hienas-on rightPatch
    let nHienasFrontPatch count hienas-on frontPatch
    let nHienasInRadius count hienas in-radius 4
    let killLeftPatch nHienasLeftPatch = 1 and nHienasRightPatch = 0 and nHienasFrontPatch = 0
    let killRightPatch nHienasRightPatch = 1 and nHienasLeftPatch = 0 and nHienasFrontPatch = 0
    let killfrontPatch nHienasFrontPatch = 1 and nHienasRightPatch = 0 and nHienasLeftPatch = 0



    ifelse inBluePatch
    [
      if (ticks - timerDescanso) > descansoLeao
      [
        let num random 101
        if num < 20
        [
        set ableToBreed 1
        ]
        fd 1
      ]
      let x random 101
      if x < 50
      [
        set energia energia + 1
      ]
      ifelse killLeftPatch
      [
        let targetHiena one-of hienas-on leftPatch
        set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
        ask leftPatch [set pcolor brown]
        ask targetHiena [die]
      ]
      [;else
        ifelse killRightPatch
        [
          let targetHiena one-of hienas-on rightPatch
          set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
          ask rightPatch [set pcolor brown]
          ask targetHiena [die]
        ]
        [;else
          ifelse killFrontPatch
          [
            let targetHiena one-of hienas-on frontPatch
            set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
            ask frontPatch [set pcolor brown]
            ask targetHiena [die]
          ]
          [;else
            andarNormal
          ]
        ]
      ]
    ]
    [
      set timerDescanso ticks     ;atualiza sempre
      ifelse energia < fomeLeao
      [
        ifelse foodOnCurrentPatch
        [
          comer
        ]
        [;else
          set energia energia - 1
          ifelse foodOnFrontPatch
          [
            fd 1
          ]
          [;else
            ifelse foodOnLeftPatch
            [
              left 90
            ]
            [;else
              ifelse foodOnRightPatch
              [
                right 90
              ]
              [;else
                ifelse killLeftPatch
                [
                  let targetHiena one-of hienas-on leftPatch
                  set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                  ask leftPatch [set pcolor brown]
                  ask targetHiena [die]
                ]
                [;else
                  ifelse killRightPatch
                  [
                    let targetHiena one-of hienas-on rightPatch
                    set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                    ask rightPatch [set pcolor brown]
                    ask targetHiena [die]
                  ]
                  [;else
                    ifelse killFrontPatch
                    [
                      let targetHiena one-of hienas-on frontPatch
                      set energia (energia - ([energia] of targetHiena) * energiaPerdidaCombate / 100)
                      ask frontPatch [set pcolor brown]
                      ask targetHiena [die]
                    ]
                    [;else
                      andarNormal
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
      [;else energia > fomeLeao (movimento especial)
        ifelse nHienasLeftPatch >= 1 and nHienasRightPatch >= 1
        and nHienasFrontPatch >= 1
        [
          set energia energia - 5
          back 2
        ]
        [;else
          ifelse nHienasRightPatch >= 1 and nHienasFrontPatch >= 1
          [
            set energia energia - 5
            back 1
            left 90
            fd 1
          ]
          [;else
            ifelse nHienasLeftPatch >= 1 and nHienasFrontPatch >= 1
            [
              set energia energia - 5
              back 1
              right 90
              fd 1
            ]
            [;else
              ifelse nHienasRightPatch >= 2 or (nHienasLeftPatch >= 1
                and nHienasRightPatch >= 1)
              [
                set energia energia - 3
                back 1
              ]
              [;else
                ifelse nHienasRightPatch >= 2
                [
                  set energia energia - 2
                  left 90
                  fd 1
                ]
                [;else
                  ifelse nHienasLeftPatch >= 2
                  [
                    set energia energia - 2
                    right 90
                    fd 1
                  ]
                  [;else
                    ifelse foodOnCurrentPatch
                    [
                      comer
                    ]
                    [;else
                      ifelse killLeftPatch
                      [
                        let targetHiena one-of hienas-on leftPatch
                        set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                        ask leftPatch [set pcolor brown]
                        ask targetHiena [die]
                      ]
                      [;else
                        ifelse killRightPatch
                        [
                          let targetHiena one-of hienas-on rightPatch
                          set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                          ask rightPatch [set pcolor brown]
                          ask targetHiena [die]
                        ]
                        [;else
                          ifelse killFrontPatch
                          [
                            let targetHiena one-of hienas-on frontPatch
                            set energia (energia - ([energia] of targetHiena) / energiaPerdidaCombate)
                            ask frontPatch [set pcolor brown]
                            ask targetHiena [die]
                          ]
                          [;else
                            ifelse nHienasInRadius > 10
                            [
                              let nearestBluePatch min-one-of patches with [pcolor = blue] [5]

                              ifelse nearestBluePatch != nobody
                              [
                                let bPatchX [pxcor] of nearestBluePatch
                                let bPatchY [pycor] of nearestBluePatch
                                set xcor bPatchX
                                set ycor bPatchY
                              ]
                              [
                                set energia energia - 1
                                andarNormal
                              ]
                            ]
                            [
                              set energia energia - 1
                              andarNormal
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end



to acaoHienaMelhorado
  ask hienas [
    let frontPatch patch-ahead 1
    let leftPatch patch-left-and-ahead 90 1
    let rightPatch patch-right-and-ahead 90 1
    let currentPatch patch-here

    let hienasOnLeft count hienas-on leftPatch
    let hienasOnRight count hienas-on rightPatch
    let hienasInFront count hienas-on frontPatch
    let hienasOnCurrent (count hienas-on currentPatch - 1)
    set nivelAgrupamento hienasOnLeft + hienasOnRight + hienasInFront + hienasOnCurrent
    let nleoesOnLeft count leoes-on leftPatch
    let nleoesOnRight count leoes-on rightPatch
    let nleoesInFront count leoes-on frontPatch
    let nleoesInCurrent count leoes-on currentPatch
    let nleoesInVizinhancaP nleoesOnLeft + nleoesOnRight + nleoesInFront + nleoesInCurrent

    let foodOnCurrentPatch pcolor = brown or pcolor = red
    let foodOnLeftPatch [pcolor] of leftPatch = red or [pcolor] of leftPatch = brown
    let foodOnRightPatch [pcolor] of rightPatch = red or [pcolor] of rightPatch = brown
    let foodOnFrontPatch [pcolor] of frontPatch = red or [pcolor] of frontPatch = brown

    let indHienasOnLeft hienas-on leftPatch
    let indHienasOnRight hienas-on rightPatch
    let indHienasInFront hienas-on frontPatch
    let indHienasInCurrent hienas-on currentPatch

    if [pcolor] of leftPatch = blue [
      set nleoesOnLeft 0
    ]
    if [pcolor] of rightPatch = blue [
      set nleoesOnRight 0
    ]
    if [pcolor] of frontPatch = blue [
      set nleoesInFront 0
    ]
    if [pcolor] of currentPatch = blue [
      set nleoesInCurrent 0
    ]

    ifelse nivelAgrupamento > 0 ;cor default pink
    [
      set color blue ;mudada
    ]
    [
      set color pink ;default
    ]

    ifelse foodOnCurrentPatch
    [
      comer
    ]
    [
      ifelse nivelAgrupamento > 1
      [
        ifelse nleoesInVizinhancaP = 1
        [
          ifelse  nleoesOnLeft = 1
          [
            let targetLeao one-of leoes-on leftPatch
            set ableToBreed 1
            let energyToDeduct  ([energia] of targetLeao) * (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

            ask indHienasOnLeft [
              set energia energia - energyToDeduct
            ]
            ask indHienasOnRight [
              set energia energia - energyToDeduct
            ]
            ask indHienasInFront [
              set energia energia - energyToDeduct
            ]
            ask indHienasInCurrent [
              set energia energia - energyToDeduct
            ]
            ask targetLeao
            [
              die
            ]
            ask leftPatch
            [
              set pcolor red
            ]
          ]
          [
            ifelse nleoesOnRight = 1
            [
              let targetLeao one-of leoes-on rightPatch
              let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

              ask indHienasOnLeft [
                set energia energia - energyToDeduct
              ]
              ask indHienasOnRight [
                set energia energia - energyToDeduct
              ]
              ask indHienasInFront [
                set energia energia - energyToDeduct
              ]
              ask indHienasInCurrent [
                set energia energia - energyToDeduct
              ]
              ask targetLeao
              [
                die
              ]
              ask rightPatch
              [
                set pcolor red
              ]
            ]
            [
              ifelse nleoesInFront = 1
              [
                let targetLeao one-of leoes-on frontPatch

                let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

                ask indHienasOnLeft [
                  set energia energia - energyToDeduct
                ]
                ask indHienasOnRight [
                  set energia energia - energyToDeduct
                ]
                ask indHienasInFront [
                  set energia energia - energyToDeduct
                ]
                ask indHienasInCurrent [
                  set energia energia - energyToDeduct
                ]
                ask targetLeao
                [
                  die
                ]
                ask frontPatch
                [
                  set pcolor red
                ]
              ]
              [
                if nLeoesInCurrent = 1
                [
                  let targetLeao one-of leoes-on currentPatch
                  let energyToDeduct  (EnergiaPerdidaCombate / 100)  / nivelAgrupamento

                  ask indHienasOnLeft [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasOnRight [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasInFront [
                    set energia energia - energyToDeduct
                  ]
                  ask indHienasInCurrent [
                    set energia energia - energyToDeduct
                  ]

                  ask targetLeao
                  [
                    die
                  ]
                  ask rightPatch
                  [
                    set pcolor red
                  ]
                ]
              ]
            ]
          ]
        ]
        [
          set energia energia - 1
          if nleoesInVizinhancaP = 0
          [
            let num random 101
            andarNormal
            let currentHeading heading
            let x xcor
            let y ycor


            ask indHienasOnLeft [
              set heading currentHeading
              if num < 90 [
              set xcor x
              set ycor y
              ]
            ]
            ask indHienasOnRight [
              set heading currentHeading
              if num < 90 [
              set xcor x
              set ycor y
              ]
            ]
            ask indHienasInFront [
              set heading currentHeading
              if num < 90 [
              set xcor x
              set ycor y
              ]
            ]
            ask indHienasInCurrent [
              set heading currentHeading
              if num < 90 [
              set xcor x
              set ycor y
              ]
            ]
          ]
        ]
      ]
      [
        set energia energia - 1
        andarNormal
      ]
    ]
    ;nao ver celulas azuis
  ]
end

to reproduzir
  ask leoes
  [
    if energia >= (2 * fomeLeao) and count leoes-on patch-here = 2
    [
      let x random 101
      ifelse x < 18 and ableToBreed = 1
      [
        set ableToBreed 0
        set energia energia / 2
        hatch 1 [move-to patch-ahead 2]
      ]
      [
        if x < 20 and ableToBreed = 1
        [
          set energia energia / 4
          set ableToBreed 0
          hatch 2 [move-to patch-ahead 2]
        ]
      ]
    ]
  ]
  ask hienas
  [
    let leoesFront count leoes-on patch-ahead 1
    let leoesLeft count leoes-on patch-left-and-ahead 90 1
    let leoesRight count leoes-on patch-right-and-ahead 90 1
    let leoesTotal leoesFront + leoesLeft + leoesRight
    if count hienas-on patch-here < 2
    [
      let x random 101

      if x < 20 and ableToBreed = 1
      [
        set ableToBreed 0
        set energia energia / 2
        hatch 1 [move-to patch-ahead 2]
      ]
    ]
  ]


end


















@#$#@#$#@
GRAPHICS-WINDOW
414
10
851
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
5
82
139
115
nCelulasAzuis
nCelulasAzuis
0
5
5.0
1
1
NIL
HORIZONTAL

BUTTON
16
432
79
465
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
88
432
151
465
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
5
10
139
43
AlimentoPeqPorte
AlimentoPeqPorte
0
20
10.0
1
1
%
HORIZONTAL

SLIDER
5
46
140
79
AlimentoGrandePorte
AlimentoGrandePorte
0
10
5.0
1
1
%
HORIZONTAL

SLIDER
5
154
177
187
nLeoes
nLeoes
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
5
191
177
224
nHienas
nHienas
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
5
228
177
261
energiaLeao
energiaLeao
0
50
25.0
1
1
NIL
HORIZONTAL

SLIDER
5
265
177
298
energiaHiena
energiaHiena
0
50
25.0
1
1
NIL
HORIZONTAL

SLIDER
4
118
176
151
energiaObtida
energiaObtida
1
50
28.0
1
1
NIL
HORIZONTAL

SLIDER
6
304
178
337
FomeLeao
FomeLeao
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
8
342
192
375
EnergiaPerdidaCombate
EnergiaPerdidaCombate
0
20
10.0
1
1
%
HORIZONTAL

PLOT
212
458
412
608
Leoes
Tempo
N Leoes
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -16710653 true "" "plot count leoes"

MONITOR
17
473
72
518
N Hienas
count hienas
17
1
11

SLIDER
11
389
183
422
descansoLeao
descansoLeao
0
30
15.0
1
1
NIL
HORIZONTAL

PLOT
440
456
640
606
Hienas
Tempo
N Hienas
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2064490 true "" "plot count hienas"

MONITOR
36
544
93
589
N Leoes
count leoes
17
1
11

SWITCH
168
43
323
76
HienasMelhoradas?
HienasMelhoradas?
0
1
-1000

SWITCH
182
90
332
123
LeoesMelhorados?
LeoesMelhorados?
0
1
-1000

SWITCH
227
177
340
210
reproduzir?
reproduzir?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

### Patches
 
	Células vermelhas -> "Alimento de grande porte" (0% a 10% do ambiente)
	Células castanhas -> "Alimento de pequeno porte" (0% a 20% do ambiente)
	Células pretas -> "Vazio"
	Células azuis -> (0 a 5 células)
	
	dao energia entre 1 e 50
	
### Comportamento das Patches
	
	Célula vermelha comida -> transforma-se em cèlula castanha
	Célula castanha comida -> tranforma-se em célula preta, devem reaparecer

### Agentes

	Leoes (caracteristicas)
		quantidade -> definido pelo utilizador
		energia -> definido pelo utilizador 

	Leoes (açoes, 1 por tick)
		comer
		andar para a frente -> -1 energia
		rodar 90 -> -1 energia 
		combater hienas
		afastar-se 
			se 2+ hienas APENAS a esquerda
			-> salta para a direita
			-> -2 energia
			
			se 2+ hienas APENAS a direita
			-> salta para a esquerda
			-> -2 energia

			se 2+ hienas APENAS a frente ou
			se 1+ hienas a esquerda e direita
			-> salta para tras
			-> -3 energia

			se 1+ hienas a esquerda e a frente
			-> salta 1 pa tras e um pa direita
			-> -5 energia
			
			se 1+ hienas a direita e a frente
			-> salta 1 pa tras e um pa esquerda
			-> -5 energia

			se 1+ hienas a esquerda e a frente e a direita
			-> salta 2 pa tras
			-> - energia
		
## Perguntas
	
	perdendo cinco (4)
	
	Dado que o principal objetivo dos agentes é o de garantir a sua sobrevivência o maior tempo possível, todos os agentes deverão ter associado um valor de nível de energia

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
