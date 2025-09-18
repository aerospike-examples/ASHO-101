import styles from "./index.module.css";
import { Link } from "react-router";
import type { Product } from "../../pages/Product";

interface Props {
    product: Product
}

const Card = ({ product }: Props) => {
    return (
        <Link 
            to={`/products/${product.item_id}`}
            className={styles['card']} 
        >
            <div className={styles['card-top']}>
                {product.decade}s
                <span>|</span>
                <span>{product.category}</span>
                <span>|</span>
                <span>{product.subcategory}</span>
            </div>
            <div className={styles['image-container']}>
                <img src={product.images.main} className={styles['image']} />
            </div>
        </Link>
    )
}

export default Card;
