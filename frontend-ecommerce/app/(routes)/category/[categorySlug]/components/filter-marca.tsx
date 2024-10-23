
"use client"

import { useGetProductField } from "@/api/getProductField";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { FilterTypes } from "@/types/filters";


const FilterMarca = () =>{
    const {result,loading}: FilterTypes = useGetProductField();

    return(
        <div className='my-5'>
            <p className='mb-3 font-bold'>Marcas</p>
            {loading && result === null && (
                <p>Cargando Marcas...</p>
            )}
            <RadioGroup>
                {result !== null && result.schema.attributes.Marca.enum.map((marca: string)=>(
                    <div key={marca} className="flex items-center space-x-2">
                        <RadioGroupItem value={marca} id={marca}/>
                        <Label htmlFor={marca}>{marca}</Label>  
                    </div>
                ))}
            </RadioGroup>
        </div>
    )
}

export default FilterMarca;