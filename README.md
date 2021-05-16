# LHP
LHP ("Lua Hypertext Processor") is an ultra minimal text file parser for embedding Lua code within other kinds of documents, just like PHP. It was created as part of a static website generator, but could in principle be used on a web server for dynamic website generation, or for any text creation task.

## Example usage
Input file:
```
<!DOCTYPE HTML>
<html>   
    <body>
      <h1>The Fibionacci sequence:</h1>
      <ul>
        <?lua
          -- Print the first ten digits of the fibonacci sequence
          local a,b = 0,1
          for n=1,10 do
            echo( "<li>" .. a .. "</li> )
            local sum = a + b              
            a = b
            b = sum
          end
        ?>
      </ul>
    </body>
</html>
```

Compiling:
```
lua lhp.lua input.lhp output.html
```

Output file:
```
<!DOCTYPE HTML>
<html>   
    <body>
      <h1>The Fibionacci sequence:</h1>
      <ul>
        <li>0</li>
        <li>1</li>
        <li>1</li>
        <li>2</li>
        <li>3</li>
        <li>5</li>
        <li>8</li>
        <li>13</li>
        <li>21</li>
        <li>34</li>
      </ul>
    </body>
</html>
