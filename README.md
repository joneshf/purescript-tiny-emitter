# Module Documentation

## Module Control.Events.TinyEmitter

### Types

    data TinyEmitter :: *


### Type Class Instances

    instance eventEmitterTinyEmitter :: EventEmitter TinyEmitter


### Values

    _emit :: forall eff e arg. (EventEmitter e) => Fn3 Event arg e (Eff (event :: EventEff | eff) e)

    emit :: forall eff e arg. (EventEmitter e) => Event -> arg -> e -> Eff (event :: EventEff | eff) e

    emitter :: forall eff. Eff (event :: EventEff | eff) TinyEmitter

    emitterHelper1 :: forall eff e fn. (EventEmitter e) => Fn3 String Event e (Eff (event :: EventEff | eff) e)

    emitterHelper2 :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit)) => Fn4 String Event fn e (Eff (event :: EventEff | eff) e)

    off :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit)) => Event -> e -> Eff (event :: EventEff | eff) e

    on :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit)) => Event -> fn -> e -> Eff (event :: EventEff | eff) e

    once :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit)) => Event -> fn -> e -> Eff (event :: EventEff | eff) e



