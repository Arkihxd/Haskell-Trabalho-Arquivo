import System.IO
import Data.Char

-- autor: Mateus Oliveira de Souza

main :: IO ()
main = do putStr "Arquivo: "
          hFlush stdout
          nome <- getLine
          txt <- readFile nome
          let texto = construirIndice txt
          imprimir texto

imprimir :: Show a => [(a, String)] -> IO ()
imprimir [] = putStrLn ""
imprimir ((n, l):ls) = do putStr (show n)
                          putStr "\t"
                          putStrLn l
                          imprimir ls

construirIndice :: [Char] -> [([Int], String)]
construirIndice texto = agrupar (ordenar (numeraPalavras (numLinhas texto)))

numLinhas :: (Num a, Enum a) => [Char] -> [(a, String)]
numLinhas [] = []
numLinhas texto = zip [1..] (lines (formataTexto texto))

numeraPalavras :: [(Int, String)] -> [(Int, String)]
numeraPalavras [] = []
numeraPalavras ((n,x):xs) = numeraPalavras' n (words x) ++ numeraPalavras xs
numeraPalavras' :: Int -> [String] -> [(Int, [Char])]
numeraPalavras' _ [] = []
numeraPalavras' n (x:xs) | length x > 3 = (n, x) : numeraPalavras' n xs
                         | otherwise = numeraPalavras' n xs

formataTexto :: [Char] -> [Char]
formataTexto [] = []
formataTexto texto = map toUpper (filtrar texto)
filtrar :: [Char] -> [Char]
filtrar = filter (\x -> isAlpha x || isSpace x || isUpper x)

ordenar :: Ord b => [(a, b)] -> [(a, b)]
ordenar [] = []
ordenar (x:xs) = ordenar [y | y <- xs, snd y <= snd x] ++ [x] ++ ordenar [y | y <- xs, snd y > snd x]

ordenarNumeros :: Ord a => [a] -> [a]
ordenarNumeros [] = []
ordenarNumeros (x:xs) = ordenarNumeros (filter (< x) xs)
                     ++ [x] ++
                     ordenarNumeros (filter (>= x) xs)

eliminarRep :: Eq a => [a] -> [a]
eliminarRep [] = []
eliminarRep (x:xs) = x: eliminarRep (filter (/=x) xs)

agrupar :: (Ord a1, Eq a2) => [(a1, a2)] -> [([a1], a2)]
agrupar [] = []
agrupar ((x,y):xys) = (eliminarRep (ordenarNumeros (agrupar' y ((x,y):xys))), y) : agrupar (filter (\x -> snd x /= y) xys)
agrupar' :: Eq t => t -> [(a, t)] -> [a]
agrupar' n [] = []
agrupar' n ((x,y):xys) | n == y = x : agrupar' n xys
                       | otherwise = agrupar' n xys