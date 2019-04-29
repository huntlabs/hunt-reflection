
module witchcraft.aggregates;

import witchcraft;

import std.algorithm;
import std.array;
import std.range;

abstract class Aggregate : Type
{
    /++
     + Looks up and returns a constructor with a parameter list that exactly
     + matches the given array of types.
     +
     + Params:
     +   parameterTypes = A parameter list the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(Type[] parameterTypes...) const
    {
        // Iterate up the inheritance tree.
        return getConstructors.retro
            .filter!(c => c.getParameterTypes == parameterTypes)
            .takeOne
            .chain(null.only)
            .front;
    }

    /++
     + Looks up and returns a constructor with a parameter list that exactly
     + matches the given array of types.
     +
     + Params:
     +   parameterTypeInfos = A parameter list the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(TypeInfo[] parameterTypeInfos) const
    {
        // Iterate up the inheritance tree.
        return getConstructors.retro
            .filter!(c => c.getParameterTypeInfos == parameterTypeInfos)
            .takeOne
            .chain(null.only)
            .front;
    }

    /++
     + Ditto, but accepts types given by variadic template arguments.
     +
     + Params:
     +   TList = A list of types the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(TList...)() const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getConstructor(types);
    }

    /++
     + Returns an array of all constructors defined by this type.
     + This does not include the default constructor.
     +
     + If a type declares no constructors, this method will return an empty
     + array.
     +
     + Returns:
     +   And array of all constructors on the aggregate type.
     ++/
    abstract const(Constructor)[] getConstructors() const;

    @property
    final override bool isAggregate() const
    {
        return true;
    }
}
