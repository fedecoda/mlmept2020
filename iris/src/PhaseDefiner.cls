Class src.PhaseDefiner
{
    ClassMethod phase(line As %String,previous As %String) As %String
    {
        IF $find(line,"preparing data")>0 {
            QUIT "datapreps"
        } ELSEIF $find(line,"determining feature columns")>0 {
            QUIT "featureengineering"
        } ELSEIF $find(line,"evaluating as a")>0 {
            QUIT "modelselection"
        } ELSEIF $find(line,"trying")>0 {
            QUIT "trainingN"
        } ELSEIF $find(line,"picking")>0 {
            QUIT "result"
        } ELSEIF $find(line,"returning model")>0 {
            QUIT "formatedresult"
        } ELSE {
            QUIT previous
        }
    }
}