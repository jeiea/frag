{-# LANGUAGE BangPatterns, FlexibleInstances, MultiParamTypeClasses #-}

{- $Id: AFRPVector2.hs,v 1.5 2004/03/22 19:46:40 antony Exp $
******************************************************************************
*                                  A F R P                                   *
*                                                                            *
*       Module:         AFRPVector2                                          *
*       Purpose:        2D vector abstraction (R^2).                         *
*       Authors:        Henrik Nilsson and Antony Courtney                   *
*                                                                            *
*             Copyright (c) Yale University, 2003                            *
*                                                                            *
******************************************************************************
-}

module AFRPVector2 (
    module AFRPVectorSpace,
    Vector2,            -- Abstract, instance of VectorSpace
    vector2,            -- :: RealFloat a => a -> a -> Vector2 a
    vector2X,           -- :: RealFloat a => Vector2 a -> a
    vector2Y,           -- :: RealFloat a => Vector2 a -> a
    vector2XY,          -- :: RealFloat a => Vector2 a -> (a, a)
    vector2Polar,       -- :: RealFloat a => a -> a -> Vector2 a
    vector2Rho,         -- :: RealFloat a => Vector2 a -> a
    vector2Theta,       -- :: RealFloat a => Vector2 a -> a
    vector2RhoTheta,    -- :: RealFloat a => Vector2 a -> (a, a)
    vector2Rotate       -- :: RealFloat a => a -> Vector2 a -> Vector2 a
) where

import AFRPVectorSpace
import AFRPForceable


------------------------------------------------------------------------------
-- 2D vector, constructors and selectors.
------------------------------------------------------------------------------

-- Restrict coefficient space to RealFloat (rather than Floating) for now.
-- While unclear if a complex coefficient space would be useful (and if the
-- result really would be a 2d vector), the only thing causing trouble is the
-- use of atan2 in vector2Theta. Maybe atan2 can be generalized?

data Vector2 a = Vector2 !a !a deriving (Eq,Show)

vector2 :: RealFloat a => a -> a -> Vector2 a
vector2 x y = Vector2 x y

vector2X :: RealFloat a => Vector2 a -> a
vector2X (Vector2 x _) = x

vector2Y :: RealFloat a => Vector2 a -> a
vector2Y (Vector2 _ y) = y

vector2XY :: RealFloat a => Vector2 a -> (a, a)
vector2XY (Vector2 x y) = (x, y)

vector2Polar :: RealFloat a => a -> a -> Vector2 a
vector2Polar rho theta = Vector2 (rho * cos theta) (rho * sin theta)

vector2Rho :: RealFloat a => Vector2 a -> a
vector2Rho (Vector2 x y) = sqrt (x * x + y * y)

vector2Theta :: RealFloat a => Vector2 a -> a
vector2Theta (Vector2 x y) = atan2 y x

vector2RhoTheta :: RealFloat a => Vector2 a -> (a, a)
vector2RhoTheta v = (vector2Rho v, vector2Theta v)

------------------------------------------------------------------------------
-- Vector space instance
------------------------------------------------------------------------------

instance RealFloat a => VectorSpace (Vector2 a) a where
    zeroVector = Vector2 0 0

    a *^ (Vector2 x y) = Vector2 (a * x) (a * y)

    (Vector2 x y) ^/ a = Vector2 (x / a) (y / a)

    negateVector (Vector2 x y) = (Vector2 (-x) (-y))

    (Vector2 x1 y1) ^+^ (Vector2 x2 y2) = Vector2 (x1 + x2) (y1 + y2)

    (Vector2 x1 y1) ^-^ (Vector2 x2 y2) = Vector2 (x1 - x2) (y1 - y2)

    (Vector2 x1 y1) `dot` (Vector2 x2 y2) = x1 * x2 + y1 * y2


------------------------------------------------------------------------------
-- Additional operations
------------------------------------------------------------------------------

vector2Rotate :: RealFloat a => a -> Vector2 a -> Vector2 a
vector2Rotate theta' v = vector2Polar (vector2Rho v) (vector2Theta v + theta')


------------------------------------------------------------------------------
-- Forceable instance
------------------------------------------------------------------------------

instance RealFloat a => Forceable (Vector2 a) where
     force = id
