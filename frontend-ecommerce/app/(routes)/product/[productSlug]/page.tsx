"use client"
import { useGetProductBySlug } from "@/api/getProductBySlug";
import { ResponseType } from "@/types/response";
import { useParams } from "next/navigation"
export default function page() {
    const params = useParams();
    const {productSlug} = params
    
    const { result }: ResponseType = useGetProductBySlug(productSlug)

    
    return(
        <p>from product page</p>
    )
}