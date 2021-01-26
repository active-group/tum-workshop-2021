module DB where

{-
   put "Mike" 25
   x = get "Mike"
   put "Mike" (x + 17)
   y = get "Mike"
   return y
-}

{-
data DBCommand = 
     Put String Int
   | Get String

type DBProgram = [DBCommand]

p1 = [Put "Mike 25", Get "Mike", 
-}

data DB result =
    Get String (Int -> DB result) -- continuation
  | Put String Int (() -> DB result)
  | Return result

p1 :: DB String
p1 = Put "Mike" 25 (\ () ->
     Get "Mike" (\ x ->
     Put "Mike" (x + 17) (\ () ->
     Get "Mike" (\ y ->
     Return (show y)))))

-- assemble DB program from parts

get :: String -> DB Int
get key = Get key (\ value -> Return value)

ptrivial = get "Mike"


put :: String -> Int -> DB ()
put key value = Put key value Return

ptrivial' x = put "Mike" (x + 17)

splice :: DB a -> (a -> DB b) -> DB b
splice (Get key cont) next = 
    Get key (\ value -> splice (cont value) next)
splice (Put key value cont) next = 
    Put key value (\ () -> splice (cont ()) next)
splice (Return result) next = next result

p1' :: DB String
p1' = put "Mike" 25 `splice` (\ () ->
      get "Mike" `splice` (\ x ->
      put "Mike" (x + 17) `splice` (\() ->
      get "Mike" `splice`(\ y ->
      Return (show y)))))

instance Functor DB where

instance Applicative DB where

instance Monad DB where
    (>>=) = splice
    return = Return

p1'' :: DB Int
p1'' = do put "Mike" 25
          x <- get "Mike"
          put "Mike" (x + 17)
          y <- get "Mike"
          return y

-- runDB :: DB a -> Map Int String -> a
-- runDBPostgreSQL :: DB a -> IO a